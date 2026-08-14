import 'package:anydoes/domain/models/planner_snapshot.dart';
import 'package:anydoes/domain/models/task.dart';
import 'package:anydoes/domain/models/recurrence_rule.dart';
import 'package:anydoes/features/tasks/tasks_controller.dart';
import 'package:flutter/material.dart';

class TaskEditor extends StatefulWidget {
  const TaskEditor({required this.snapshot, super.key});

  final PlannerSnapshot snapshot;

  @override
  State<TaskEditor> createState() => _TaskEditorState();
}

class _TaskEditorState extends State<TaskEditor> {
  final _title = TextEditingController();
  final _notes = TextEditingController();
  final _duration = TextEditingController();
  final _minimum = TextEditingController(text: '25');
  final _maximum = TextEditingController(text: '90');
  final _tags = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  TaskPriority _priority = TaskPriority.normal;
  String _listId = 'inbox';
  String? _assigneeId;
  bool _allowSplit = false;
  bool _includeInPlan = false;
  RecurrenceFrequency? _recurrenceFrequency;

  @override
  void dispose() {
    _title.dispose();
    _notes.dispose();
    _duration.dispose();
    _minimum.dispose();
    _maximum.dispose();
    _tags.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop(
      TaskDraft(
        title: _title.text,
        notes: _notes.text,
        listId: _listId,
        priority: _priority,
        estimatedMinutes: _duration.text.trim().isEmpty
            ? null
            : int.parse(_duration.text),
        allowSplit: _allowSplit,
        minimumSessionMinutes: int.parse(_minimum.text),
        maximumSessionMinutes: int.parse(_maximum.text),
        assigneeProfileId: _assigneeId,
        includeInMyPlan: _includeInPlan,
        tagNames: _tags.text.split(','),
        recurrence: _recurrenceFrequency == null
            ? null
            : RecurrenceDraft(frequency: _recurrenceFrequency!),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('New task'),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  key: const Key('task-title-field'),
                  controller: _title,
                  autofocus: true,
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Enter a title'
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _notes,
                  minLines: 2,
                  maxLines: 4,
                  decoration: const InputDecoration(labelText: 'Notes'),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _listId,
                  decoration: const InputDecoration(labelText: 'List'),
                  items: [
                    for (final list in widget.snapshot.lists)
                      DropdownMenuItem(value: list.id, child: Text(list.name)),
                  ],
                  onChanged: (value) =>
                      setState(() => _listId = value ?? 'inbox'),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<TaskPriority>(
                  initialValue: _priority,
                  decoration: const InputDecoration(labelText: 'Priority'),
                  items: [
                    for (final priority in TaskPriority.values)
                      DropdownMenuItem(
                        value: priority,
                        child: Text(priority.name),
                      ),
                  ],
                  onChanged: (value) =>
                      setState(() => _priority = value ?? TaskPriority.normal),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  key: const Key('task-duration-field'),
                  controller: _duration,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Estimated minutes',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return null;
                    final minutes = int.tryParse(value);
                    return minutes == null || minutes <= 0
                        ? 'Enter positive minutes'
                        : null;
                  },
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Allow task splitting'),
                  value: _allowSplit,
                  onChanged: (value) => setState(() => _allowSplit = value),
                ),
                if (_allowSplit)
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _minimum,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Minimum session',
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _maximum,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Maximum session',
                          ),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String?>(
                  initialValue: _assigneeId,
                  decoration: const InputDecoration(labelText: 'Assignee'),
                  items: [
                    const DropdownMenuItem(
                      value: null,
                      child: Text('Unassigned'),
                    ),
                    for (final profile in widget.snapshot.profiles)
                      DropdownMenuItem(
                        value: profile.id,
                        child: Text(profile.name),
                      ),
                  ],
                  onChanged: (value) => setState(() => _assigneeId = value),
                ),
                if (_assigneeId != null && _assigneeId != 'me')
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Include in my plan'),
                    value: _includeInPlan,
                    onChanged: (value) =>
                        setState(() => _includeInPlan = value),
                  ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _tags,
                  decoration: const InputDecoration(
                    labelText: 'Tags',
                    hintText: 'home, errands',
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<RecurrenceFrequency?>(
                  initialValue: _recurrenceFrequency,
                  decoration: const InputDecoration(labelText: 'Repeat'),
                  items: [
                    const DropdownMenuItem(
                      value: null,
                      child: Text('Does not repeat'),
                    ),
                    for (final frequency in RecurrenceFrequency.values)
                      DropdownMenuItem(
                        value: frequency,
                        child: Text(frequency.name),
                      ),
                  ],
                  onChanged: (value) =>
                      setState(() => _recurrenceFrequency = value),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _save, child: const Text('Create task')),
      ],
    );
  }
}
