import 'package:anydoes/domain/models/task.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime.utc(2026, 8, 15, 8);

  PlannerTask validTask({
    String id = 'task-1',
    String title = 'Prepare presentation',
    int? estimatedMinutes = 60,
    int? remainingMinutes,
    int minimumSessionMinutes = 25,
    int maximumSessionMinutes = 90,
    DateTime? earliestStart,
    DateTime? deadline,
    String? parentTaskId,
  }) {
    return PlannerTask.create(
      id: id,
      title: title,
      listId: 'inbox',
      estimatedMinutes: estimatedMinutes,
      remainingMinutes: remainingMinutes,
      minimumSessionMinutes: minimumSessionMinutes,
      maximumSessionMinutes: maximumSessionMinutes,
      earliestStart: earliestStart,
      deadline: deadline,
      parentTaskId: parentTaskId,
      createdAt: now,
    );
  }

  test('rejects a title containing only whitespace', () {
    expect(() => validTask(title: '   '), throwsArgumentError);
  });

  test('rejects a negative estimated duration', () {
    expect(() => validTask(estimatedMinutes: -1), throwsArgumentError);
  });

  test('rejects remaining work above the estimate', () {
    expect(
      () => validTask(estimatedMinutes: 45, remainingMinutes: 60),
      throwsArgumentError,
    );
  });

  test('rejects a minimum session shorter than five minutes', () {
    expect(() => validTask(minimumSessionMinutes: 4), throwsArgumentError);
  });

  test('rejects a maximum session below the minimum', () {
    expect(
      () => validTask(minimumSessionMinutes: 30, maximumSessionMinutes: 25),
      throwsArgumentError,
    );
  });

  test('rejects self-parenting', () {
    expect(
      () => validTask(id: 'task-1', parentTaskId: 'task-1'),
      throwsArgumentError,
    );
  });

  test('rejects a deadline before the earliest start', () {
    expect(
      () => validTask(
        earliestStart: DateTime.utc(2026, 8, 16, 10),
        deadline: DateTime.utc(2026, 8, 16, 9),
      ),
      throwsArgumentError,
    );
  });

  test('a task without an estimate is valid but cannot auto-schedule', () {
    final task = validTask(estimatedMinutes: null);

    expect(task.estimatedMinutes, isNull);
    expect(task.remainingMinutes, isNull);
    expect(task.canAutoSchedule, isFalse);
  });

  test('defaults remaining work to the estimate and normalizes UTC dates', () {
    final localCreatedAt = DateTime(2026, 8, 15, 8);
    final task = PlannerTask.create(
      id: 'task-2',
      title: '  Focus session  ',
      listId: 'inbox',
      estimatedMinutes: 75,
      createdAt: localCreatedAt,
    );

    expect(task.title, 'Focus session');
    expect(task.remainingMinutes, 75);
    expect(task.minimumSessionMinutes, 25);
    expect(task.maximumSessionMinutes, 90);
    expect(task.createdAt.isUtc, isTrue);
  });
}
