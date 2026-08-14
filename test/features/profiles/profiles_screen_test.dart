import 'package:anydoes/app/anydoes_app.dart';
import 'package:anydoes/app/providers.dart';
import 'package:anydoes/core/time/clock.dart';
import 'package:anydoes/data/database/app_database.dart';
import 'package:anydoes/data/repositories/drift_planner_repository.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Me is protected and another local profile can be added', (
    tester,
  ) async {
    final database = AppDatabase.forTesting(
      NativeDatabase.memory(
        setup: (raw) => raw.execute('PRAGMA foreign_keys = ON'),
      ),
    );
    addTearDown(database.close);
    final repository = DriftPlannerRepository(database);
    await repository.initializeDefaults();

    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          plannerRepositoryProvider.overrideWithValue(repository),
          appClockProvider.overrideWithValue(
            FixedAppClock(DateTime.utc(2026, 8, 15, 8)),
          ),
        ],
        child: const AnydoesApp(),
      ),
    );
    await tester.tap(find.text('Profiles'));
    await tester.pumpAndSettle();

    expect(find.text('Me'), findsOneWidget);
    expect(find.byKey(const Key('delete-profile-me')), findsNothing);

    await tester.tap(find.byKey(const Key('add-profile')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('profile-name-field')),
      'Alex Rivera',
    );
    await tester.tap(find.widgetWithText(FilledButton, 'Add profile'));
    await tester.pumpAndSettle();

    expect(find.text('Alex Rivera'), findsOneWidget);
    expect((await repository.currentSnapshot()).profiles, hasLength(2));
  });
}
