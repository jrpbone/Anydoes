import 'package:anydoes/domain/models/planner_snapshot.dart';
import 'package:anydoes/domain/models/recurrence_rule.dart';
import 'package:anydoes/domain/models/task.dart';
import 'package:anydoes/features/tasks/tasks_controller.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum _RecurrenceEnd { never, onDate, afterCount }

class TaskEditor extends StatefulWidget {
  const TaskEditor({required this.snapshot, this.initialTask, super.key});

  final PlannerSnapshot snapshot;
  final PlannerTask? initialTask;

  @override
  State<TaskEditor> createState() => _TaskEditorState();
}

class _TaskEditorState extends State<TaskEditor> {
  late final TextEditingController _title;
  late final TextEditingController _notes;
  late final TextEditingController _duration;
  late final TextEditingController _minimum;
  late final TextEditingController _maximum;
  late final TextEditingController _tags;
  late final TextEditingController _recurrenceInterval;
  late final TextEditingController _recurrenceCount;
  final _formKey = GlobalKey<FormState>();

  late TaskPriority _priority;
  late String _listId;
  String? _parentTaskId;
  String? _assigneeId;
  late bool _allowSplit;
  late bool _includeInPlan;
  DateTime? _earliestStart;
  DateTime? _deadline;
  RecurrenceFrequency? _recurrenceFrequency;
  Set<int> _weekdays = {};
  _RecurrenceEnd _recurrenceEnd = _RecurrenceEnd.never;
  DateTime? _recurrenceUntil;

  @override
  void initState() {
    super.initState();
    final task = widget.initialTask;
    final recurrence = task?.recurrenceRuleId == null
        ? null
        : widget.snapshot.recurrenceRules
              .where((rule) => rule.id == task!.recurrenceRuleId)
              .firstOrNull;
    _title = TextEditingController(text: task?.title ?? '');
    _notes = TextEditingController(text: task?.notes ?? '');
    _duration = TextEditingController(
      text: task?.estimatedMinutes?.toString() ?? '',
    );
    _minimum = TextEditingController(
      text: (task?.minimumSessionMinutes ?? 25).toString(),
    );
    _maximum = TextEditingController(
      text: (task?.maximumSessionMinutes ?? 90).toString(),
    );
    _tags = TextEditingController(
      text: widget.snapshot.tags
          .where((tag) => task?.tagIds.contains(tag.id) ?? false)
          .map((tag) => tag.name)
          .join(', '),
    );
    _recurrenceInterval = TextEditingController(
      text: (recurrence?.interval ?? 1).toString(),
    );
    _recurrenceCount = TextEditingController(
      text: recurrence?.occurrenceCount?.toString() ?? '10',
    );
    _priority = task?.priority ?? TaskPriority.normal;
    _listId = task?.listId ?? 'inbox';
    _parentTaskId = task?.parentTaskId;
    _assigneeId = task?.assigneeProfileId;
    _allowSplit = task?.allowSplit ?? false;
    _includeInPlan = task?.includeInMyPlan ?? false;
    _earliestStart = task?.earliestStart;
    _deadline = task?.deadline;
    _recurrenceFrequency = recurrence?.frequency;
    _weekdays = {...?recurrence?.weekdays};
    _recurrenceUntil = recurrence?.until;
    _recurrenceEnd = recurrence?.until != null
        ? _RecurrenceEnd.onDate
        : recurrence?.occurrenceCount != null
        ? _RecurrenceEnd.afterCount
        : _RecurrenceEnd.never;
  }

  @override
  void dispose() {
    _title.dispose();
    _notes.dispose();
    _duration.dispose();
    _minimum.dispose();
    _maximum.dispose();
    _tags.dispose();
    _recurrenceInterval.dispose();
    _recurrenceCount.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final minimum = int.parse(_minimum.text);
    final maximum = int.parse(_maximum.text);
    if (maximum < minimum) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Maximum session must be at least minimum.'),
        ),
      );
      return;
    }
    if (_earliestStart != null &&
        _deadline != null &&
        _deadline!.isBefore(_earliestStart!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Deadline cannot precede earliest start.'),
        ),
      );
      return;
    }
    Navigator.of(context).pop(
      TaskDraft(
        title: _title.text,
        notes: _notes.text,
        listId: _listId,
        parentTaskId: _parentTaskId,
        priority: _priority,
        earliestStart: _earliestStart,
        deadline: _deadline,
        estimatedMinutes: _duration.text.trim().isEmpty
            ? null
            : int.parse(_duration.text),
        allowSplit: _allowSplit,
        minimumSessionMinutes: minimum,
        maximumSessionMinutes: maximum,
        assigneeProfileId: _assigneeId,
        includeInMyPlan: _includeInPlan,
        tagNames: _tags.text.split(','),
        recurrence: _recurrenceFrequency == null
            ? null
            : RecurrenceDraft(
                frequency: _recurrenceFrequency!,
                interval: int.parse(_recurrenceInterval.text),
                weekdays: _weekdays,
                until: _recurrenceEnd == _RecurrenceEnd.onDate
                    ? _recurrenceUntil
                    : null,
                occurrenceCount: _recurrenceEnd == _RecurrenceEnd.afterCount
                    ? int.parse(_recurrenceCount.text)
                    : null,
              ),
      ),
    );
  }

  Future<DateTime?> _pickDateTime(DateTime? current) async {
    final local = current?.toLocal() ?? DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: local,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date == null || !mounted) return current;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(local),
    );
    if (time == null) return current;
    return DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    ).toUtc();
  }

  Future<DateTime?> _pickDate(DateTime? current) async {
    final local = current?.toLocal() ?? DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: local,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    return date == null
        ? current
        : DateTime.utc(date.year, date.month, date.day);
  }

  @override
  Widget build(BuildContext context) {
    final task = widget.initialTask;
    final parentCandidates = widget.snapshot.tasks.where(
      (candidate) => candidate.id != task?.id,
    );
    return AlertDialog(
      title: Text(task == null ? 'New task' : 'Edit task'),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
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
                  isExpanded: true,
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
                DropdownButtonFormField<String?>(
                  key: const Key('task-parent-field'),
                  isExpanded: true,
                  initialValue: _parentTaskId,
                  decoration: const InputDecoration(labelText: 'Subtask of'),
                  items: [
                    const DropdownMenuItem(
                      value: null,
                      child: Text('No parent task'),
                    ),
                    for (final candidate in parentCandidates)
                      DropdownMenuItem(
                        value: candidate.id,
                        child: Text(candidate.title),
                      ),
                  ],
                  onChanged: (value) => setState(() => _parentTaskId = value),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<TaskPriority>(
                  isExpanded: true,
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
                _DateTimeField(
                  key: const Key('task-earliest-field'),
                  label: 'Earliest start',
                  value: _earliestStart,
                  onPick: () async {
                    final value = await _pickDateTime(_earliestStart);
                    if (mounted) setState(() => _earliestStart = value);
                  },
                  onClear: _earliestStart == null
                      ? null
                      : () => setState(() => _earliestStart = null),
                ),
                const SizedBox(height: 8),
                _DateTimeField(
                  key: const Key('task-deadline-field'),
                  label: 'Deadline',
                  value: _deadline,
                  onPick: () async {
                    final value = await _pickDateTime(_deadline);
                    if (mounted) setState(() => _deadline = value);
                  },
                  onClear: _deadline == null
                      ? null
                      : () => setState(() => _deadline = null),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  key: const Key('task-duration-field'),
                  controller: _duration,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Estimated minutes',
                  ),
                  validator: _positiveOptional,
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
                          validator: _positiveRequired,
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
                          validator: _positiveRequired,
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String?>(
                  isExpanded: true,
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
                  key: const Key('task-repeat-field'),
                  isExpanded: true,
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
                  onChanged: (value) => setState(() {
                    _recurrenceFrequency = value;
                    if (value == RecurrenceFrequency.weekly &&
                        _weekdays.isEmpty) {
                      _weekdays = {DateTime.now().weekday};
                    }
                  }),
                ),
                if (_recurrenceFrequency != null) ...[
                  const SizedBox(height: 12),
                  TextFormField(
                    key: const Key('task-recurrence-interval'),
                    controller: _recurrenceInterval,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Repeat every (${_recurrenceFrequency!.name})',
                    ),
                    validator: _positiveRequired,
                  ),
                  if (_recurrenceFrequency == RecurrenceFrequency.weekly) ...[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      children: [
                        for (var weekday = 1; weekday <= 7; weekday++)
                          FilterChip(
                            key: Key('task-weekday-$weekday'),
                            label: Text(_weekdayLabel(weekday)),
                            selected: _weekdays.contains(weekday),
                            onSelected: (selected) => setState(() {
                              selected
                                  ? _weekdays.add(weekday)
                                  : _weekdays.remove(weekday);
                            }),
                          ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 8),
                  DropdownButtonFormField<_RecurrenceEnd>(
                    key: const Key('task-recurrence-end'),
                    isExpanded: true,
                    initialValue: _recurrenceEnd,
                    decoration: const InputDecoration(labelText: 'Ends'),
                    items: const [
                      DropdownMenuItem(
                        value: _RecurrenceEnd.never,
                        child: Text('Never'),
                      ),
                      DropdownMenuItem(
                        value: _RecurrenceEnd.onDate,
                        child: Text('On a date'),
                      ),
                      DropdownMenuItem(
                        value: _RecurrenceEnd.afterCount,
                        child: Text('After occurrences'),
                      ),
                    ],
                    onChanged: (value) => setState(
                      () => _recurrenceEnd = value ?? _RecurrenceEnd.never,
                    ),
                  ),
                  if (_recurrenceEnd == _RecurrenceEnd.onDate)
                    _DateTimeField(
                      label: 'Last occurrence',
                      value: _recurrenceUntil,
                      dateOnly: true,
                      onPick: () async {
                        final value = await _pickDate(_recurrenceUntil);
                        if (mounted) {
                          setState(() => _recurrenceUntil = value);
                        }
                      },
                      onClear: null,
                    ),
                  if (_recurrenceEnd == _RecurrenceEnd.afterCount)
                    TextFormField(
                      controller: _recurrenceCount,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Occurrence count',
                      ),
                      validator: _positiveRequired,
                    ),
                ],
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
        FilledButton(
          onPressed: _save,
          child: Text(task == null ? 'Create task' : 'Save changes'),
        ),
      ],
    );
  }

  String? _positiveOptional(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    return _positiveRequired(value);
  }

  String? _positiveRequired(String? value) {
    final number = int.tryParse(value ?? '');
    return number == null || number <= 0 ? 'Enter a positive number' : null;
  }

  String _weekdayLabel(int weekday) =>
      const ['M', 'T', 'W', 'T', 'F', 'S', 'S'][weekday - 1];
}

class _DateTimeField extends StatelessWidget {
  const _DateTimeField({
    required this.label,
    required this.value,
    required this.onPick,
    required this.onClear,
    this.dateOnly = false,
    super.key,
  });

  final String label;
  final DateTime? value;
  final VoidCallback onPick;
  final VoidCallback? onClear;
  final bool dateOnly;

  @override
  Widget build(BuildContext context) => InputDecorator(
    decoration: InputDecoration(labelText: label),
    child: Row(
      children: [
        Expanded(
          child: Text(
            value == null
                ? 'Not set'
                : dateOnly
                ? DateFormat.yMMMd().format(value!.toLocal())
                : DateFormat.yMMMd().add_jm().format(value!.toLocal()),
          ),
        ),
        if (onClear != null)
          IconButton(
            tooltip: 'Clear $label',
            onPressed: onClear,
            icon: const Icon(Icons.close),
          ),
        TextButton(
          onPressed: onPick,
          child: Text(value == null ? 'Set' : 'Change'),
        ),
      ],
    ),
  );
}
