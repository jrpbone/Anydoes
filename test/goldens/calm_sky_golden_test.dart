import 'package:anydoes/domain/models/task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_support/app_harness.dart';

void main() {
  for (final entry in <(String, double)>[
    ('compact', 390),
    ('medium', 800),
    ('expanded', 1440),
  ]) {
    testWidgets('empty Plan ${entry.$1} golden', (tester) async {
      await pumpTestApp(tester, width: entry.$2);
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('baselines/plan-empty-${entry.$1}.png'),
      );
    });
  }

  testWidgets('task editor compact golden', (tester) async {
    await pumpTestApp(tester, width: 390);
    await tester.tap(find.text('Tasks'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('open-task-editor')));
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('baselines/task-editor-compact.png'),
    );
  });

  testWidgets('profiles medium golden', (tester) async {
    await pumpTestApp(tester, width: 800);
    await tester.tap(find.byIcon(Icons.people_outline));
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('baselines/profiles-medium.png'),
    );
  });

  testWidgets('settings expanded golden', (tester) async {
    await pumpTestApp(tester, width: 1440);
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('baselines/settings-expanded.png'),
    );
  });

  testWidgets('proposal and conflict medium golden', (tester) async {
    await pumpTestApp(
      tester,
      width: 800,
      seed: (repository) => repository.saveTasks([
        PlannerTask.create(
          id: 'short',
          title: 'Review launch brief',
          listId: 'inbox',
          createdAt: fixedTestNow,
          estimatedMinutes: 60,
        ),
        PlannerTask.create(
          id: 'long',
          title: 'Prepare annual strategy',
          listId: 'inbox',
          createdAt: fixedTestNow,
          estimatedMinutes: 600,
        ),
      ]),
    );
    await tester.tap(find.widgetWithText(FilledButton, 'Plan my tasks'));
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('baselines/plan-proposal-conflict-medium.png'),
    );
  });
}
