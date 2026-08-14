import 'package:anydoes/domain/models/planner_snapshot.dart';
import 'package:anydoes/domain/portability/dayplan_document.dart';

final class ImportCounts {
  const ImportCounts({
    required this.tasks,
    required this.blocks,
    required this.lists,
    required this.tags,
    required this.profiles,
    required this.recurrenceRules,
  });

  final int tasks;
  final int blocks;
  final int lists;
  final int tags;
  final int profiles;
  final int recurrenceRules;
}

final class ImportPreview {
  const ImportPreview({
    required this.kind,
    required this.snapshot,
    required this.counts,
    required this.collisions,
    required this.warnings,
    required this.allowedModes,
    required this.idMaps,
  });

  final DayplanKind kind;
  final PlannerSnapshot snapshot;
  final ImportCounts counts;
  final List<String> collisions;
  final List<String> warnings;
  final List<String> allowedModes;
  final Map<String, Map<String, String>> idMaps;
}
