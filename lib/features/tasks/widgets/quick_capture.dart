import 'package:flutter/material.dart';

class QuickCapture extends StatefulWidget {
  const QuickCapture({required this.onSubmit, super.key});

  final Future<void> Function(String title) onSubmit;

  @override
  State<QuickCapture> createState() => _QuickCaptureState();
}

class _QuickCaptureState extends State<QuickCapture> {
  final _controller = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit(String value) async {
    if (_saving || value.trim().isEmpty) return;
    setState(() => _saving = true);
    try {
      await widget.onSubmit(value);
      _controller.clear();
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      key: const Key('quick-capture-field'),
      controller: _controller,
      enabled: !_saving,
      textInputAction: TextInputAction.done,
      onSubmitted: _submit,
      decoration: InputDecoration(
        hintText: 'Add a task…',
        prefixIcon: const Icon(Icons.add_circle_outline),
        suffixIcon: _saving
            ? const Padding(
                padding: EdgeInsets.all(14),
                child: SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            : IconButton(
                tooltip: 'Add task',
                onPressed: () => _submit(_controller.text),
                icon: const Icon(Icons.arrow_upward_rounded),
              ),
      ),
    );
  }
}
