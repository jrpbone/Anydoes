import 'package:anydoes/core/result/app_failure.dart';
import 'package:anydoes/core/time/clock.dart';
import 'package:anydoes/data/database/app_database.dart';
import 'package:anydoes/data/portability/dayplan_file_service.dart';
import 'package:anydoes/data/repositories/drift_planner_repository.dart';
import 'package:anydoes/domain/models/planner_snapshot.dart';
import 'package:anydoes/domain/models/task.dart';
import 'package:anydoes/domain/models/task_list.dart';
import 'package:anydoes/domain/portability/dayplan_codec.dart';
import 'package:anydoes/domain/repositories/planner_repository.dart';
import 'package:anydoes/features/settings/backup_controller.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  final now = DateTime.utc(2026, 8, 15, 8);
  late AppDatabase database;
  late DriftPlannerRepository repository;
  late FakeDayplanFileService files;

  setUpAll(() => registerFallbackValue(PlannerSnapshot()));

  setUp(() async {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    repository = DriftPlannerRepository(database);
    await repository.initializeDefaults();
    files = FakeDayplanFileService();
  });

  tearDown(() => database.close());

  BackupController controller([PlannerRepository? target]) => BackupController(
    target ?? repository,
    files,
    const DayplanCodec(),
    FixedAppClock(now),
  );

  test('full backup export and replace restore round-trip user data', () async {
    await repository.saveTask(
      PlannerTask.create(
        id: 'task-1',
        title: 'Keep me',
        listId: 'inbox',
        createdAt: now,
        estimatedMinutes: 45,
      ),
    );
    final sourceController = controller();
    addTearDown(sourceController.dispose);
    expect(await sourceController.exportBackup(), isTrue);
    final exported = files.savedSource!;

    final destinationDatabase = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(destinationDatabase.close);
    final destination = DriftPlannerRepository(destinationDatabase);
    await destination.initializeDefaults();
    files.readSource = exported;
    final restore = controller(destination);
    addTearDown(restore.dispose);

    expect(await restore.previewImport(), isNotNull);
    expect(await restore.applyReplace(confirmed: false), isFalse);
    expect((await destination.currentSnapshot()).tasks, isEmpty);
    expect(await restore.applyReplace(confirmed: true), isTrue);
    expect((await destination.currentSnapshot()).tasks.single.title, 'Keep me');
  });

  test(
    'merge preserves local-only records and imported values win collisions',
    () async {
      final imported = PlannerTask.create(
        id: 'same',
        title: 'Imported title',
        listId: 'inbox',
        createdAt: now,
      );
      await repository.saveTask(imported);
      final source = controller();
      addTearDown(source.dispose);
      await source.exportBackup();

      final destinationDatabase = AppDatabase.forTesting(
        NativeDatabase.memory(),
      );
      addTearDown(destinationDatabase.close);
      final destination = DriftPlannerRepository(destinationDatabase);
      await destination.initializeDefaults();
      await destination.saveTasks([
        imported.copyWith(title: 'Local title'),
        PlannerTask.create(
          id: 'local-only',
          title: 'Local only',
          listId: 'inbox',
          createdAt: now,
        ),
      ]);
      files.readSource = files.savedSource;
      final merge = controller(destination);
      addTearDown(merge.dispose);
      await merge.previewImport();

      expect(await merge.applyMerge(), isTrue);
      final tasks = (await destination.currentSnapshot()).tasks;
      expect(tasks, hasLength(2));
      expect(
        tasks.singleWhere((task) => task.id == 'same').title,
        'Imported title',
      );
      expect(tasks.any((task) => task.id == 'local-only'), isTrue);
    },
  );

  test(
    'shared list import remaps ids and leaves unrelated data untouched',
    () async {
      await repository.saveList(
        TaskList(id: 'work', name: 'Work', createdAt: now),
      );
      await repository.saveTask(
        PlannerTask.create(
          id: 'shared-task',
          title: 'Shared work',
          listId: 'work',
          createdAt: now,
        ),
      );
      final source = controller();
      addTearDown(source.dispose);
      await source.exportList('work');

      final destinationDatabase = AppDatabase.forTesting(
        NativeDatabase.memory(),
      );
      addTearDown(destinationDatabase.close);
      final destination = DriftPlannerRepository(destinationDatabase);
      await destination.initializeDefaults();
      await destination.saveTask(
        PlannerTask.create(
          id: 'unrelated',
          title: 'Private local data',
          listId: 'inbox',
          createdAt: now,
        ),
      );
      files.readSource = files.savedSource;
      final import = controller(destination);
      addTearDown(import.dispose);
      await import.previewImport();

      expect(await import.importList(), isTrue);
      final snapshot = await destination.currentSnapshot();
      expect(snapshot.tasks.any((task) => task.id == 'unrelated'), isTrue);
      final shared = snapshot.tasks.singleWhere(
        (task) => task.title == 'Shared work',
      );
      expect(shared.id, isNot('shared-task'));
      expect(snapshot.blocks, isEmpty);
    },
  );

  test('cancelled picker and corrupt source never mutate local data', () async {
    await repository.saveTask(
      PlannerTask.create(
        id: 'safe',
        title: 'Safe',
        listId: 'inbox',
        createdAt: now,
      ),
    );
    final backup = controller();
    addTearDown(backup.dispose);

    files.readSource = null;
    expect(await backup.previewImport(), isNull);
    files.readSource = '{"broken":true}';
    expect(await backup.previewImport(), isNull);
    expect(backup.state.failure, isNotNull);
    expect((await repository.currentSnapshot()).tasks.single.id, 'safe');
  });

  test(
    'failed transactional apply retains preview and reports recovery',
    () async {
      final source = controller();
      addTearDown(source.dispose);
      await source.exportBackup();
      files.readSource = files.savedSource;

      final failing = MockPlannerRepository();
      when(failing.currentSnapshot).thenAnswer((_) async => PlannerSnapshot());
      when(() => failing.replaceSnapshot(any())).thenThrow(
        const AppFailure(
          code: AppFailureCode.persistence,
          message: 'Injected write failure.',
          recovery: 'Nothing changed.',
        ),
      );
      final restore = controller(failing);
      addTearDown(restore.dispose);
      await restore.previewImport();

      expect(await restore.applyReplace(confirmed: true), isFalse);
      expect(restore.state.preview, isNotNull);
      expect(restore.state.failure, contains('Nothing changed'));
    },
  );
}

final class FakeDayplanFileService implements DayplanFileGateway {
  String? readSource;
  String? savedSource;
  String? savedName;

  @override
  Future<String> localTimeZone() async => 'UTC';

  @override
  Future<String?> read() async => readSource;

  @override
  Future<bool> saveFullBackup(
    String source, {
    required String suggestedName,
  }) async {
    savedSource = source;
    savedName = suggestedName;
    return true;
  }

  @override
  Future<bool> saveSharedList(
    String source, {
    required String suggestedName,
  }) async {
    savedSource = source;
    savedName = suggestedName;
    return true;
  }
}

final class MockPlannerRepository extends Mock implements PlannerRepository {}
