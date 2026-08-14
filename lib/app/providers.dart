import 'package:anydoes/core/time/clock.dart';
import 'package:anydoes/data/database/app_database.dart';
import 'package:anydoes/data/repositories/drift_planner_repository.dart';
import 'package:anydoes/domain/repositories/planner_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appClockProvider = Provider<AppClock>((ref) => const SystemAppClock());

final databaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();
  ref.onDispose(database.close);
  return database;
});

final plannerRepositoryProvider = Provider<PlannerRepository>(
  (ref) => DriftPlannerRepository(ref.watch(databaseProvider)),
);
