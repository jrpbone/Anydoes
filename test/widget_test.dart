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
  Future<void> pumpAtWidth(WidgetTester tester, double width) async {
    final database = AppDatabase.forTesting(
      NativeDatabase.memory(
        setup: (raw) => raw.execute('PRAGMA foreign_keys = ON'),
      ),
    );
    addTearDown(database.close);
    final repository = DriftPlannerRepository(database);
    await repository.initializeDefaults();
    await tester.binding.setSurfaceSize(Size(width, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          plannerRepositoryProvider.overrideWithValue(repository),
          appClockProvider.overrideWithValue(
            FixedAppClock(DateTime.utc(2026, 8, 17, 8)),
          ),
        ],
        child: const AnydoesApp(),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('compact width exposes all destinations in bottom navigation', (
    tester,
  ) async {
    await pumpAtWidth(tester, 390);

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(NavigationRail), findsNothing);
    for (final label in ['Plan', 'Tasks', 'Profiles', 'Settings']) {
      expect(find.text(label), findsWidgets);
    }
  });

  testWidgets('medium width uses a navigation rail', (tester) async {
    await pumpAtWidth(tester, 800);

    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
  });

  testWidgets('expanded width uses the persistent sidebar', (tester) async {
    await pumpAtWidth(tester, 1440);

    expect(find.byKey(const Key('expanded-sidebar')), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
    expect(find.text('Anydoes'), findsOneWidget);
  });
}
