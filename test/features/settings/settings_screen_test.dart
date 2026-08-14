import 'package:anydoes/app/anydoes_app.dart';
import 'package:anydoes/app/providers.dart';
import 'package:anydoes/data/database/app_database.dart';
import 'package:anydoes/data/repositories/drift_planner_repository.dart';
import 'package:anydoes/domain/models/availability.dart';
import 'package:anydoes/domain/models/planning_preferences.dart';
import 'package:anydoes/features/settings/settings_controller.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase database;
  late DriftPlannerRepository repository;

  setUp(() async {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    repository = DriftPlannerRepository(database);
    await repository.initializeDefaults();
  });

  tearDown(() => database.close());

  test(
    'availability edits persist and overlapping windows are rejected',
    () async {
      final controller = SettingsController(repository);
      addTearDown(controller.dispose);
      await controller.ready;

      await controller.addWeeklyWindow(DateTime.monday, 18 * 60, 20 * 60);
      expect(
        (await repository.currentSnapshot()).weeklyAvailability.where(
          (window) => window.weekday == DateTime.monday,
        ),
        hasLength(2),
      );

      await expectLater(
        controller.addWeeklyWindow(DateTime.monday, 10 * 60, 11 * 60),
        throwsA(isA<ArgumentError>()),
      );
      expect(controller.state.failure, contains('overlap'));
    },
  );

  test(
    'date exceptions replace a day with unavailable or custom windows',
    () async {
      final controller = SettingsController(repository);
      addTearDown(controller.dispose);
      await controller.ready;
      final date = DateTime(2026, 8, 20);

      await controller.setDateException(date, const []);
      expect(
        (await repository.currentSnapshot())
            .availabilityExceptions
            .single
            .windows,
        isEmpty,
      );

      await controller.setDateException(date, [
        AvailabilityWindow(
          weekday: date.weekday,
          startMinute: 12 * 60,
          endMinute: 15 * 60,
        ),
      ]);
      final exception =
          (await repository.currentSnapshot()).availabilityExceptions.single;
      expect(exception.windows.single.startMinute, 12 * 60);
    },
  );

  test(
    'planning and appearance preferences are bounded and persisted',
    () async {
      final controller = SettingsController(repository);
      addTearDown(controller.dispose);
      await controller.ready;

      await controller.updatePlanning(
        horizonDays: 21,
        minimumSessionMinutes: 20,
        maximumSessionMinutes: 120,
        notificationOffsetMinutes: 10,
      );
      await controller.setAppearance(
        themeMode: AppThemeMode.dark,
        highContrast: true,
        reduceMotion: true,
      );

      final saved = (await repository.currentSnapshot()).preferences;
      expect(saved.horizonDays, 21);
      expect(saved.defaultMaximumSessionMinutes, 120);
      expect(saved.themeMode, AppThemeMode.dark);
      expect(saved.highContrast, isTrue);
      expect(saved.reduceMotion, isTrue);

      await expectLater(
        controller.updatePlanning(horizonDays: 31),
        throwsA(isA<ArgumentError>()),
      );
    },
  );

  testWidgets(
    'Settings exposes all sections and applies dark mode immediately',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(
        ProviderScope(
          overrides: [plannerRepositoryProvider.overrideWithValue(repository)],
          child: const AnydoesApp(),
        ),
      );
      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();

      expect(find.text('Weekly availability'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text('Date exceptions'),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Date exceptions'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text('Planning defaults'),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Planning defaults'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text('Appearance & accessibility'),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Appearance & accessibility'), findsOneWidget);

      await tester.tap(find.byKey(const Key('theme-dark')));
      await tester.pumpAndSettle();
      expect(
        Theme.of(tester.element(find.text('Settings'))).brightness,
        Brightness.dark,
      );

      await tester.tap(find.byKey(const Key('reduce-motion')));
      await tester.pumpAndSettle();
      expect(
        MediaQuery.of(tester.element(find.text('Settings'))).disableAnimations,
        isTrue,
      );
    },
  );
}
