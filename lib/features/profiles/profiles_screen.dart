import 'package:anydoes/domain/models/profile.dart';
import 'package:anydoes/features/profiles/profiles_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfilesScreen extends ConsumerWidget {
  const ProfilesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profilesControllerProvider);
    final controller = ref.read(profilesControllerProvider.notifier);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
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
                        'Profiles',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Local household members—no accounts required.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                FilledButton.icon(
                  key: const Key('add-profile'),
                  onPressed: () => _addProfile(context, controller),
                  icon: const Icon(Icons.person_add_alt_1),
                  label: const Text('Add'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (state.failure != null)
              Card(
                color: Theme.of(context).colorScheme.errorContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    '${state.failure!.message} ${state.failure!.recovery}',
                  ),
                ),
              ),
            Expanded(
              child: state.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.separated(
                      itemCount: state.profiles.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final profile = state.profiles[index];
                        return _ProfileCard(
                          profile: profile,
                          onDelete: profile.isMe
                              ? null
                              : () => _deleteProfile(
                                  context,
                                  controller,
                                  profile,
                                ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addProfile(
    BuildContext context,
    ProfilesController controller,
  ) async {
    var enteredName = '';
    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add local profile'),
        content: TextField(
          key: const Key('profile-name-field'),
          autofocus: true,
          textInputAction: TextInputAction.done,
          decoration: const InputDecoration(labelText: 'Name'),
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
            child: const Text('Add profile'),
          ),
        ],
      ),
    );
    if (name != null && name.trim().isNotEmpty) {
      await controller.addProfile(name);
    }
  }

  Future<void> _deleteProfile(
    BuildContext context,
    ProfilesController controller,
    LocalProfile profile,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete ${profile.name}?'),
        content: const Text('Assigned tasks will become unassigned.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed ?? false) {
      await controller.deleteProfile(profile);
    }
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.profile, required this.onDelete});

  final LocalProfile profile;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 10,
        ),
        leading: CircleAvatar(
          backgroundColor: Color(profile.colorValue),
          foregroundColor: Colors.white,
          child: Text(profile.initials),
        ),
        title: Text(profile.name),
        subtitle: Text(
          profile.isMe ? 'Included in your plan by default' : 'Local profile',
        ),
        trailing: onDelete == null
            ? const Chip(label: Text('Primary'))
            : IconButton(
                key: Key('delete-profile-${profile.id}'),
                tooltip: 'Delete ${profile.name}',
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline),
              ),
      ),
    );
  }
}
