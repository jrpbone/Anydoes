import 'package:anydoes/domain/models/task_list.dart';
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
          onComplete: (value) => controller.toggleComplete(task, value),
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

  Future<void> _openEditor(BuildContext context) async {
    final draft = await showDialog<TaskDraft>(
      context: context,
      builder: (_) => TaskEditor(snapshot: state.snapshot),
    );
    if (draft != null) {
      await controller.createTask(draft);
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
