import 'package:anydoes/app/providers.dart';
import 'package:anydoes/domain/models/schedule_block.dart';
import 'package:anydoes/domain/models/task.dart';
import 'package:anydoes/domain/scheduling/planning_result.dart';
import 'package:anydoes/features/plan/plan_controller.dart';
import 'package:anydoes/features/plan/plan_state.dart';
import 'package:anydoes/features/plan/widgets/block_editor.dart';
import 'package:anydoes/features/plan/widgets/conflict_card.dart';
import 'package:anydoes/features/plan/widgets/day_timeline.dart';
import 'package:anydoes/features/plan/widgets/task_queue.dart';
import 'package:anydoes/features/plan/widgets/week_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class PlanScreen extends ConsumerStatefulWidget {
  const PlanScreen({super.key});

  @override
  ConsumerState<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends ConsumerState<PlanScreen> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = ref.read(appClockProvider).now();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(planControllerProvider);
    final controller = ref.read(planControllerProvider.notifier);
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 650;
        final expanded = constraints.maxWidth >= 1000;
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.all(compact ? 14 : 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _header(context, state, controller, compact),
                if (state.failure != null) ...[
                  const SizedBox(height: 8),
                  Card(
                    color: Theme.of(context).colorScheme.errorContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        '${state.failure!.message} ${state.failure!.recovery}',
                      ),
                    ),
                  ),
                ],
                if (state.proposalBlocks.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  _proposalActions(controller),
                ],
                if (state.conflicts.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 270,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: state.conflicts.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        final conflict = state.conflicts[index];
                        return SizedBox(
                          width: compact ? constraints.maxWidth - 28 : 390,
                          child: ConflictCard(
                            conflict: conflict,
                            task: _task(state, conflict.taskId),
                            onAction: (action) => controller
                                .applyRecoveryAction(conflict, action),
                          ),
                        );
                      },
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                Expanded(
                  child: compact
                      ? _day(state, controller)
                      : Row(
                          children: [
                            Expanded(
                              child: expanded
                                  ? _week(state, controller)
                                  : _day(state, controller),
                            ),
                            const SizedBox(width: 12),
                            SizedBox(
                              key: const Key('persistent-task-queue'),
                              width: expanded ? 310 : 260,
                              child: TaskQueue(tasks: state.unscheduledTasks),
                            ),
                          ],
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _header(
    BuildContext context,
    PlanState state,
    PlanController controller,
    bool compact,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Plan',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  Text(
                    DateFormat('MMMM yyyy').format(_selectedDate.toLocal()),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            if (compact)
              IconButton.filledTonal(
                key: const Key('open-task-queue'),
                tooltip: 'Open unscheduled task queue',
                onPressed: () => _showQueue(context, state),
                icon: const Icon(Icons.inbox_outlined),
              ),
          ],
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            IconButton.outlined(
              tooltip: 'Previous day or week',
              onPressed: () => setState(
                () => _selectedDate = _selectedDate.subtract(
                  const Duration(days: 1),
                ),
              ),
              icon: const Icon(Icons.chevron_left),
            ),
            OutlinedButton(
              onPressed: () => setState(
                () => _selectedDate = ref.read(appClockProvider).now(),
              ),
              child: const Text('Today'),
            ),
            IconButton.outlined(
              tooltip: 'Next day or week',
              onPressed: () => setState(
                () =>
                    _selectedDate = _selectedDate.add(const Duration(days: 1)),
              ),
              icon: const Icon(Icons.chevron_right),
            ),
            FilledButton.icon(
              onPressed: state.isPlanning ? null : controller.createProposal,
              icon: state.isPlanning
                  ? const SizedBox.square(
                      dimension: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.auto_awesome),
              label: const Text('Plan my tasks'),
            ),
            if (state.snapshot.blocks.any(
              (block) => block.isGenerated && !block.isLocked,
            ))
              TextButton.icon(
                onPressed: controller.replan,
                icon: const Icon(Icons.refresh),
                label: const Text('Replan'),
              ),
          ],
        ),
      ],
    );
  }

  Widget _proposalActions(PlanController controller) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            const Expanded(
              child: Text('Review the suggested schedule before saving.'),
            ),
            TextButton(
              onPressed: controller.discard,
              child: const Text('Discard'),
            ),
            const SizedBox(width: 8),
            FilledButton(
              onPressed: controller.acceptAll,
              child: const Text('Accept all'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _day(PlanState state, PlanController controller) => DayTimeline(
    date: _selectedDate,
    accepted: state.snapshot.blocks,
    proposed: state.proposalBlocks,
    tasks: state.snapshot.tasks,
    onAcceptedTap: (block) => _editAccepted(block, state, controller),
    onProposedTap: (block) => _editProposal(block, state, controller),
  );

  Widget _week(PlanState state, PlanController controller) => WeekCalendar(
    anchor: _selectedDate,
    accepted: state.snapshot.blocks,
    proposed: state.proposalBlocks,
    tasks: state.snapshot.tasks,
    onAcceptedTap: (block) => _editAccepted(block, state, controller),
    onProposedTap: (block) => _editProposal(block, state, controller),
  );

  Future<void> _showQueue(BuildContext context, PlanState state) =>
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (_) => SafeArea(
          child: SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.7,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: TaskQueue(tasks: state.unscheduledTasks),
            ),
          ),
        ),
      );

  Future<void> _editProposal(
    PlannedBlock block,
    PlanState state,
    PlanController controller,
  ) async {
    final context = this.context;
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => BlockEditor(
        title: _task(state, block.taskId)?.title ?? 'Task',
        start: block.start,
        end: block.end,
        proposed: true,
        onMove: (start) {
          controller.moveProposalBlock(block.id, start);
          Navigator.pop(dialogContext);
        },
        onResize: (duration) {
          controller.resizeProposalBlock(block.id, duration);
          Navigator.pop(dialogContext);
        },
        onAccept: () {
          controller.acceptBlock(block.id);
          Navigator.pop(dialogContext);
        },
        onRemove: () {
          controller.removeProposalBlock(block.id);
          Navigator.pop(dialogContext);
        },
      ),
    );
  }

  Future<void> _editAccepted(
    ScheduleBlock block,
    PlanState state,
    PlanController controller,
  ) async {
    final context = this.context;
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => BlockEditor(
        title: _task(state, block.taskId)?.title ?? block.note ?? 'Fixed event',
        start: block.start,
        end: block.end,
        proposed: false,
        onMove: (start) {
          controller.moveAcceptedBlock(block, start);
          Navigator.pop(dialogContext);
        },
        onResize: (duration) {
          controller.resizeAcceptedBlock(block, duration);
          Navigator.pop(dialogContext);
        },
        onComplete: block.taskId == null
            ? null
            : () {
                controller.completeBlock(block.id);
                Navigator.pop(dialogContext);
              },
        onSkip: block.taskId == null
            ? null
            : () {
                controller.skipBlock(block);
                Navigator.pop(dialogContext);
              },
      ),
    );
  }

  PlannerTask? _task(PlanState state, String? id) =>
      state.snapshot.tasks.where((task) => task.id == id).firstOrNull;
}
