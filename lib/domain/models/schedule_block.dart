enum ScheduleBlockState { proposed, accepted }

enum BlockCompletionState { pending, completed, skipped }

final class ScheduleBlock {
  ScheduleBlock({
    required String id,
    required DateTime start,
    required DateTime end,
    this.taskId,
    this.state = ScheduleBlockState.accepted,
    this.isLocked = false,
    this.completionState = BlockCompletionState.pending,
    this.note,
    this.isGenerated = true,
  }) : id = id.trim(),
       start = start.toUtc(),
       end = end.toUtc() {
    if (this.id.isEmpty) throw ArgumentError.value(id, 'id', 'Required');
    if (!this.end.isAfter(this.start)) {
      throw ArgumentError.value(end, 'end', 'Must be after start');
    }
  }

  final String id;
  final String? taskId;
  final DateTime start;
  final DateTime end;
  final ScheduleBlockState state;
  final bool isLocked;
  final BlockCompletionState completionState;
  final String? note;
  final bool isGenerated;

  Duration get duration => end.difference(start);

  ScheduleBlock copyWith({
    DateTime? start,
    DateTime? end,
    ScheduleBlockState? state,
    bool? isLocked,
    BlockCompletionState? completionState,
    String? note,
  }) {
    return ScheduleBlock(
      id: id,
      taskId: taskId,
      start: start ?? this.start,
      end: end ?? this.end,
      state: state ?? this.state,
      isLocked: isLocked ?? this.isLocked,
      completionState: completionState ?? this.completionState,
      note: note ?? this.note,
      isGenerated: isGenerated,
    );
  }
}
