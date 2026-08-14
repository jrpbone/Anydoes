import 'package:anydoes/features/settings/backup_controller.dart';
import 'package:anydoes/features/settings/widgets/import_preview_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DataPortabilitySection extends ConsumerWidget {
  const DataPortabilitySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(backupControllerProvider);
    final controller = ref.read(backupControllerProvider.notifier);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Backup & portability',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            const Text(
              'One validated .dayplan file works for complete backups and shared lists.',
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton.tonalIcon(
                  key: const Key('export-backup'),
                  onPressed: state.isBusy ? null : controller.exportBackup,
                  icon: const Icon(Icons.file_upload_outlined),
                  label: const Text('Export backup'),
                ),
                OutlinedButton.icon(
                  key: const Key('import-dayplan'),
                  onPressed: state.isBusy
                      ? null
                      : () => _preview(context, controller),
                  icon: const Icon(Icons.file_download_outlined),
                  label: const Text('Import .dayplan'),
                ),
              ],
            ),
            if (state.isBusy) ...[
              const SizedBox(height: 12),
              const LinearProgressIndicator(),
            ],
            if (state.message != null) ...[
              const SizedBox(height: 10),
              Text(state.message!),
            ],
            if (state.failure != null) ...[
              const SizedBox(height: 10),
              Text(
                state.failure!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _preview(
    BuildContext context,
    BackupController controller,
  ) async {
    final preview = await controller.previewImport();
    if (preview == null || !context.mounted) return;
    final action = await showDialog<ImportPreviewAction>(
      context: context,
      builder: (_) => ImportPreviewDialog(preview: preview),
    );
    if (action == null) {
      controller.cancelPreview();
      return;
    }
    if (!context.mounted) return;
    switch (action) {
      case ImportPreviewAction.merge:
        await controller.applyMerge();
      case ImportPreviewAction.importList:
        await controller.importList();
      case ImportPreviewAction.replace:
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Replace all local data?'),
            content: const Text(
              'This removes the current planner and restores only the selected backup.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Replace everything'),
              ),
            ],
          ),
        );
        if (confirmed == true) {
          await controller.applyReplace(confirmed: true);
        }
    }
  }
}
