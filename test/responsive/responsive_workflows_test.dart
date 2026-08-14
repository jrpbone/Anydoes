import 'package:anydoes/app/anydoes_app.dart';
import 'package:anydoes/domain/models/task.dart';
import 'package:anydoes/features/plan/plan_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_support/app_harness.dart';

void main() {
  for (final width in [390.0, 800.0, 1440.0]) {
    testWidgets('create, plan, accept, and complete at ${width.round()} px', (
      tester,
    ) async {
      final repository = await pumpTestApp(
        tester,
        width: width,
        seed: (repository) => repository.saveTask(
          PlannerTask.create(
            id: 'workflow-task',
            title: 'Finish launch brief',
            listId: 'inbox',
            createdAt: fixedTestNow,
            estimatedMinutes: 60,
          ),
        ),
      );

      await tester.tap(find.widgetWithText(FilledButton, 'Plan my tasks'));
      await tester.pumpAndSettle();
      final planState = ProviderScope.containerOf(
        tester.element(find.byType(AnydoesApp)),
      ).read(planControllerProvider);
      expect(
        planState.proposalBlocks,
        hasLength(1),
        reason: 'conflicts: ${planState.conflicts.length}',
      );
      expect(planState.conflicts, isEmpty);
      if (width < 650) {
        await tester.scrollUntilVisible(
          find.text('Proposed'),
          300,
          scrollable: find.byType(Scrollable).first,
        );
      }
      expect(find.text('Proposed'), findsOneWidget);
      expect((await repository.currentSnapshot()).blocks, isEmpty);

      await tester.tap(find.widgetWithText(FilledButton, 'Accept all'));
      await tester.pumpAndSettle();
      expect((await repository.currentSnapshot()).blocks, hasLength(1));

      if (width < 650 && find.text('Finish launch brief').evaluate().isEmpty) {
        await tester.scrollUntilVisible(
          find.text('Finish launch brief'),
          300,
          scrollable: find.byType(Scrollable).first,
        );
      }
      await tester.tap(find.text('Finish launch brief').first);
      await tester.pumpAndSettle();
      expect(find.text('Complete block'), findsOneWidget);
      await tester.tap(find.text('Complete block'));
      await tester.pumpAndSettle();

      final snapshot = await repository.currentSnapshot();
      expect(snapshot.tasks.single.remainingMinutes, 0);
      expect(snapshot.blocks.single.completionState.name, 'completed');
    });
  }
}
