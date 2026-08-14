import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_support/app_harness.dart';

void main() {
  testWidgets('icon actions have semantics and 48 pixel touch targets', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await pumpTestApp(tester, width: 390, height: 844);

    final queue = find.byKey(const Key('open-task-queue'));
    expect(
      find.bySemanticsLabel(RegExp('Open unscheduled task queue')),
      findsOneWidget,
    );
    expect(tester.getSize(queue).width, greaterThanOrEqualTo(48));
    expect(tester.getSize(queue).height, greaterThanOrEqualTo(48));

    await tester.tap(find.text('Tasks'));
    await tester.pumpAndSettle();
    final editor = find.byKey(const Key('open-task-editor'));
    expect(
      find.bySemanticsLabel(RegExp('Open full task editor')),
      findsOneWidget,
    );
    expect(tester.getSize(editor).width, greaterThanOrEqualTo(48));
    expect(tester.getSize(editor).height, greaterThanOrEqualTo(48));
    semantics.dispose();
  });

  testWidgets('200 percent text remains usable across primary screens', (
    tester,
  ) async {
    await pumpTestApp(tester, width: 390, height: 844, textScale: 2);
    expect(tester.takeException(), isNull);

    for (final destination in ['Tasks', 'Profiles', 'Settings', 'Plan']) {
      await tester.tap(find.text(destination).last);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: destination);
    }
  });

  testWidgets('keyboard focus traverses interactive planner controls', (
    tester,
  ) async {
    await pumpTestApp(tester, width: 800);

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    final first = FocusManager.instance.primaryFocus;
    expect(first, isNotNull);
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    expect(FocusManager.instance.primaryFocus, isNot(same(first)));
  });
}
