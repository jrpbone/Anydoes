import 'package:anydoes/domain/models/availability.dart';
import 'package:anydoes/domain/models/schedule_block.dart';
import 'package:anydoes/domain/models/task.dart';

final class PlanningInput {
  PlanningInput({
    required DateTime now,
    required this.horizonDays,
    required List<PlannerTask> tasks,
    required List<ScheduleBlock> occupiedBlocks,
    required List<AvailabilityWindow> weeklyAvailability,
    required List<AvailabilityException> availabilityExceptions,
    this.primaryProfileId = 'me',
    this.reconsiderUnlockedGeneratedBlocks = false,
  }) : now = now.toUtc(),
       tasks = List.unmodifiable(tasks),
       occupiedBlocks = List.unmodifiable(occupiedBlocks),
       weeklyAvailability = List.unmodifiable(weeklyAvailability),
       availabilityExceptions = List.unmodifiable(availabilityExceptions) {
    if (horizonDays < 7 || horizonDays > 30) {
      throw ArgumentError.value(
        horizonDays,
        'horizonDays',
        'Must be 7 through 30',
      );
    }
  }

  final DateTime now;
  final int horizonDays;
  final List<PlannerTask> tasks;
  final List<ScheduleBlock> occupiedBlocks;
  final List<AvailabilityWindow> weeklyAvailability;
  final List<AvailabilityException> availabilityExceptions;
  final String primaryProfileId;
  final bool reconsiderUnlockedGeneratedBlocks;
}
