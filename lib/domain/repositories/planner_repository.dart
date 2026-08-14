import 'package:anydoes/domain/models/availability.dart';
import 'package:anydoes/domain/models/planner_snapshot.dart';
import 'package:anydoes/domain/models/profile.dart';
import 'package:anydoes/domain/models/recurrence_rule.dart';
import 'package:anydoes/domain/models/schedule_block.dart';
import 'package:anydoes/domain/models/tag.dart';
import 'package:anydoes/domain/models/task.dart';
import 'package:anydoes/domain/models/task_list.dart';

enum ListDeletionPolicy { moveTasksToInbox, deleteTasks }

enum RestoreMode { merge, replace }

abstract interface class PlannerRepository {
  Stream<PlannerSnapshot> watchSnapshot();
  Future<PlannerSnapshot> currentSnapshot();
  Future<void> initializeDefaults();
  Future<void> saveTask(PlannerTask task);
  Future<void> saveTaskWithRecurrence(
    PlannerTask task,
    RecurrenceRule recurrenceRule,
  );
  Future<void> saveTasks(Iterable<PlannerTask> tasks);
  Future<void> saveList(TaskList list);
  Future<void> saveTag(TaskTag tag);
  Future<void> saveProfile(LocalProfile profile);
  Future<void> saveRecurrenceRule(RecurrenceRule rule);
  Future<void> saveAvailability({
    required List<AvailabilityWindow> weekly,
    required List<AvailabilityException> exceptions,
  });
  Future<void> acceptProposal(Iterable<ScheduleBlock> blocks);
  Future<void> saveBlock(ScheduleBlock block);
  Future<void> completeBlock(String blockId, DateTime completedAt);
  Future<void> completeTask(
    String taskId,
    DateTime completedAt, {
    required bool removeFutureBlocks,
  });
  Future<void> deleteList(String listId, ListDeletionPolicy policy);
  Future<void> deleteProfile(String profileId);
  Future<void> replaceSnapshot(PlannerSnapshot snapshot);
  Future<void> mergeSnapshot(PlannerSnapshot snapshot);
}
