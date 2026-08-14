import 'package:anydoes/domain/models/task_list.dart';
import 'package:anydoes/domain/models/task.dart';
import 'package:anydoes/domain/models/schedule_block.dart';
import 'package:anydoes/domain/repositories/planner_repository.dart';
import 'package:anydoes/features/tasks/tasks_controller.dart';
import 'package:anydoes/features/tasks/widgets/quick_capture.dart';
import 'package:anydoes/features/tasks/widgets/task_editor.dart';
import 'package:anydoes/features/tasks/widgets/task_filters.dart';
import 'package:anydoes/features/tasks/widgets/task_tile.dart';
import 'package:anydoes/features/settings/backup_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TasksScreen extends ConsumerWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(tasksControllerProvider);
    final controller = ref.read(tasksControllerProvider.notifier);

    return LayoutBuilder(
      builder: (context, constraints) {
        final showSidebar = constraints.maxWidth >= 900;
        final content = _TaskContent(
          state: state,
          controller: controller,
          showListPicker: !showSidebar,
        );
        if (!showSidebar) return content;
        return Row(
          children: [
            SizedBox(
              width: 220,
              child: _ListSidebar(
                lists: state.snapshot.lists,
                selectedId: state.query.listId,
                onSelected: controller.selectList,
                onAdd: () => _createList(context, controller),
              ),
            ),
            VerticalDivider(
              width: 1,
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
            Expanded(child: content),
          ],
        );
      },
    );
  }

  Future<void> _createList(
    BuildContext context,
    TasksController controller,
  ) async {
    var enteredName = '';
    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New list'),
        content: TextField(
          autofocus: true,
          decoration: const InputDecoration(labelText: 'List name'),
          onChanged: (value) => enteredName = value,
          onSubmitted: (value) => Navigator.pop(context, value),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, enteredName),
            child: const Text('Create'),
          ),
        ],
      ),
    );
    if (name != null && name.trim().isNotEmpty) {
      await controller.createList(name);
    }
  }
}

class _TaskContent extends StatelessWidget {
  const _TaskContent({
    required this.state,
    required this.controller,
    required this.showListPicker,
  });

  final TasksState state;
  final TasksController controller;
  final bool showListPicker;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tasks',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      Text(
                        '${state.visibleTasks.length} visible',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Semantics(
                  label: 'Open full task editor',
                  button: true,
                  child: IconButton.filledTonal(
                    key: const Key('open-task-editor'),
                    tooltip: 'Open full task editor',
                    onPressed: () => _openEditor(context),
                    icon: const Icon(Icons.edit_calendar_outlined),
                  ),
                ),
                if (state.query.listId != null) ...[
                  const SizedBox(width: 8),
                  IconButton.outlined(
                    key: const Key('export-selected-list'),
                    tooltip: 'Export selected list',
                    onPressed: () => _exportList(context, state.query.listId!),
                    icon: const Icon(Icons.ios_share_outlined),
                  ),
                  if (state.query.listId != 'inbox') ...[
                    const SizedBox(width: 8),
                    IconButton.outlined(
                      key: const Key('delete-selected-list'),
                      tooltip: 'Delete selected list',
                      onPressed: () =>
                          _deleteSelectedList(context, state.query.listId!),
                      icon: const Icon(Icons.delete_outline),
                    ),
                  ],
                ],
              ],
            ),
            const SizedBox(height: 18),
            QuickCapture(onSubmit: controller.quickCapture),
            const SizedBox(height: 12),
            TextField(
              key: const Key('task-search-field'),
              onChanged: controller.setSearch,
              decoration: const InputDecoration(
                hintText: 'Search tasks',
                prefixIcon: Icon(Icons.search),
              ),
            ),
            if (showListPicker) ...[
              const SizedBox(height: 10),
              _CompactListPicker(
                lists: state.snapshot.lists,
                selectedId: state.query.listId,
                onSelected: controller.selectList,
              ),
            ],
            const SizedBox(height: 10),
            TaskFilters(
              query: state.query,
              onStatusChanged: controller.setStatus,
              profiles: state.snapshot.profiles,
              tags: state.snapshot.tags,
              onPriorityChanged: controller.setPriority,
              onAssigneeChanged: controller.setAssignee,
              onTagChanged: controller.setTag,
            ),
            if (state.failure != null) ...[
              const SizedBox(height: 8),
              MaterialBanner(
                content: Text(
                  '${state.failure!.message} ${state.failure!.recovery}',
                ),
                actions: [
                  TextButton(onPressed: () {}, child: const Text('Dismiss')),
                ],
              ),
            ],
            const SizedBox(height: 8),
            Expanded(child: _taskList()),
          ],
        ),
      ),
    );
  }

  Widget _taskList() {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.visibleTasks.isEmpty) {
      return const Center(child: Text('No tasks match this view.'));
    }
    return ListView.separated(
      itemCount: state.visibleTasks.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final task = state.visibleTasks[index];
        return TaskTile(
          task: task,
          onTap: () => _openEditor(context, task),
          onComplete: (value) => _toggleComplete(context, task, value),
          onArchive: () => controller.archive(task),
        );
      },
    );
  }

  Future<void> _exportList(BuildContext context, String listId) async {
    final container = ProviderScope.containerOf(context);
    final saved = await container
        .read(backupControllerProvider.notifier)
        .exportList(listId);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(saved ? 'List exported.' : 'List export cancelled.'),
      ),
    );
  }

  Future<void> _openEditor(
    BuildContext context, [
    PlannerTask? existing,
  ]) async {
    final draft = await showDialog<TaskDraft>(
      context: context,
      builder: (_) =>
          TaskEditor(snapshot: state.snapshot, initialTask: existing),
    );
    if (draft != null) {
      if (existing == null) {
        await controller.createTask(draft);
      } else {
        await controller.updateTask(existing, draft);
      }
    }
  }

  Future<void> _deleteSelectedList(BuildContext context, String listId) async {
    final taskCount = state.snapshot.tasks
        .where((task) => task.listId == listId)
        .length;
    final policy = await showDialog<ListDeletionPolicy>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete list?'),
        content: Text(
          taskCount == 0
              ? 'This removes the selected list.'
              : 'This list contains $taskCount task${taskCount == 1 ? '' : 's'}. Choose what happens to them.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          if (taskCount > 0)
            TextButton(
              onPressed: () => Navigator.pop(
                dialogContext,
                ListDeletionPolicy.moveTasksToInbox,
              ),
              child: const Text('Move tasks to Inbox'),
            ),
          FilledButton(
            onPressed: () =>
                Navigator.pop(dialogContext, ListDeletionPolicy.deleteTasks),
            child: Text(
              taskCount == 0 ? 'Delete list' : 'Delete list and tasks',
            ),
          ),
        ],
      ),
    );
    if (policy != null) await controller.deleteList(listId, policy);
  }

  Future<void> _toggleComplete(
    BuildContext context,
    PlannerTask task,
    bool complete,
  ) async {
    if (!complete) {
      await controller.toggleComplete(task, false);
      return;
    }
    final hasPendingBlocks = state.snapshot.blocks.any(
      (block) =>
          block.taskId == task.id &&
          block.completionState == BlockCompletionState.pending,
    );
    if (!hasPendingBlocks) {
      await controller.completeTask(task, removeFutureBlocks: false);
      return;
    }
    final removeBlocks = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Complete ${task.title}?'),
        content: const Text(
          'This task still has calendar blocks. You can keep them for reference or remove future sessions.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Complete and keep blocks'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Complete and remove blocks'),
          ),
        ],
      ),
    );
    if (removeBlocks != null) {
      await controller.completeTask(task, removeFutureBlocks: removeBlocks);
    }
  }
}

class _CompactListPicker extends StatelessWidget {
  const _CompactListPicker({
    required this.lists,
    required this.selectedId,
    required this.onSelected,
  });

  final List<TaskList> lists;
  final String? selectedId;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ChoiceChip(
            label: const Text('All'),
            selected: selectedId == null,
            onSelected: (_) => onSelected(null),
          ),
          for (final list in lists)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: ChoiceChip(
                label: Text(list.name),
                selected: selectedId == list.id,
                onSelected: (_) => onSelected(list.id),
              ),
            ),
        ],
      ),
    );
  }
}

class _ListSidebar extends StatelessWidget {
  const _ListSidebar({
    required this.lists,
    required this.selectedId,
    required this.onSelected,
    required this.onAdd,
  });

  final List<TaskList> lists;
  final String? selectedId;
  final ValueChanged<String?> onSelected;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
              selected: selectedId == null,
              leading: const Icon(Icons.all_inbox_outlined),
              title: const Text('All tasks'),
              onTap: () => onSelected(null),
            ),
            for (final list in lists)
              ListTile(
                selected: selectedId == list.id,
                leading: const Icon(Icons.list_alt_outlined),
                title: Text(list.name),
                onTap: () => onSelected(list.id),
              ),
            const Spacer(),
            TextButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add),
              label: const Text('New list'),
            ),
          ],
        ),
      ),
    );
  }
}
