import 'package:anydoes/domain/models/availability.dart';
import 'package:anydoes/domain/models/planning_preferences.dart';
import 'package:anydoes/domain/models/profile.dart';
import 'package:anydoes/domain/models/recurrence_rule.dart';
import 'package:anydoes/domain/models/schedule_block.dart';
import 'package:anydoes/domain/models/tag.dart';
import 'package:anydoes/domain/models/task.dart';
import 'package:anydoes/domain/models/task_list.dart';

final class PlannerSnapshot {
  PlannerSnapshot({
    List<PlannerTask> tasks = const [],
    List<ScheduleBlock> blocks = const [],
    List<TaskList> lists = const [],
    List<TaskTag> tags = const [],
    List<LocalProfile> profiles = const [],
    List<RecurrenceRule> recurrenceRules = const [],
    List<AvailabilityWindow> weeklyAvailability = const [],
    List<AvailabilityException> availabilityExceptions = const [],
    PlanningPreferences? preferences,
  }) : tasks = List.unmodifiable(tasks),
       blocks = List.unmodifiable(blocks),
       lists = List.unmodifiable(lists),
       tags = List.unmodifiable(tags),
       profiles = List.unmodifiable(profiles),
       recurrenceRules = List.unmodifiable(recurrenceRules),
       weeklyAvailability = List.unmodifiable(weeklyAvailability),
       availabilityExceptions = List.unmodifiable(availabilityExceptions),
       preferences = preferences ?? PlanningPreferences();

  final List<PlannerTask> tasks;
  final List<ScheduleBlock> blocks;
  final List<TaskList> lists;
  final List<TaskTag> tags;
  final List<LocalProfile> profiles;
  final List<RecurrenceRule> recurrenceRules;
  final List<AvailabilityWindow> weeklyAvailability;
  final List<AvailabilityException> availabilityExceptions;
  final PlanningPreferences preferences;

  PlannerSnapshot copyWith({
    List<PlannerTask>? tasks,
    List<ScheduleBlock>? blocks,
    List<TaskList>? lists,
    List<TaskTag>? tags,
    List<LocalProfile>? profiles,
    List<RecurrenceRule>? recurrenceRules,
    List<AvailabilityWindow>? weeklyAvailability,
    List<AvailabilityException>? availabilityExceptions,
    PlanningPreferences? preferences,
  }) => PlannerSnapshot(
    tasks: tasks ?? this.tasks,
    blocks: blocks ?? this.blocks,
    lists: lists ?? this.lists,
    tags: tags ?? this.tags,
    profiles: profiles ?? this.profiles,
    recurrenceRules: recurrenceRules ?? this.recurrenceRules,
    weeklyAvailability: weeklyAvailability ?? this.weeklyAvailability,
    availabilityExceptions:
        availabilityExceptions ?? this.availabilityExceptions,
    preferences: preferences ?? this.preferences,
  );
}
