import 'package:anydoes/domain/portability/dayplan_document.dart';
import 'package:anydoes/domain/portability/import_preview.dart';
import 'package:flutter/material.dart';

enum ImportPreviewAction { merge, replace, importList }

class ImportPreviewDialog extends StatelessWidget {
  const ImportPreviewDialog({required this.preview, super.key});

  final ImportPreview preview;

  @override
  Widget build(BuildContext context) {
    final counts = preview.counts;
    return AlertDialog(
      title: Text(
        preview.kind == DayplanKind.fullBackup
            ? 'Review backup import'
            : 'Review shared list',
      ),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${counts.tasks} tasks • ${counts.lists} lists • '
                '${counts.blocks} calendar blocks',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              if (preview.warnings.isNotEmpty)
                for (final warning in preview.warnings)
                  _Notice(icon: Icons.schedule_outlined, text: warning),
              if (preview.collisions.isNotEmpty)
                _Notice(
                  icon: Icons.merge_outlined,
                  text:
                      '${preview.collisions.length} matching IDs will use imported values when merged.',
                ),
              if (preview.kind == DayplanKind.sharedList)
                const _Notice(
                  icon: Icons.security_outlined,
                  text:
                      'The list will be imported with new IDs. Calendar blocks and settings are not included.',
                ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        if (preview.kind == DayplanKind.fullBackup) ...[
          OutlinedButton(
            onPressed: () =>
                Navigator.pop(context, ImportPreviewAction.replace),
            child: const Text('Replace'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, ImportPreviewAction.merge),
            child: const Text('Merge'),
          ),
        ] else
          FilledButton(
            onPressed: () =>
                Navigator.pop(context, ImportPreviewAction.importList),
            child: const Text('Import list'),
          ),
      ],
    );
  }
}

class _Notice extends StatelessWidget {
  const _Notice({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: 8),
        Expanded(child: Text(text)),
      ],
    ),
  );
}
