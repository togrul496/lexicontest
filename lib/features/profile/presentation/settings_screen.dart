import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/lexicon_scaffold.dart';
import '../../auth/data/auth_repository.dart';
import '../data/profile_repository.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionControllerProvider);
    return LexiconScaffold(
      title: 'Settings',
      child: ListView(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Appearance & language', style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: session.theme,
                    decoration: const InputDecoration(labelText: 'Theme'),
                    items: const [
                      DropdownMenuItem(value: 'system', child: Text('System')),
                      DropdownMenuItem(value: 'light', child: Text('Light')),
                      DropdownMenuItem(value: 'dark', child: Text('Dark')),
                    ],
                    onChanged: (value) async {
                      if (value == null) return;
                      await ref.read(profileRepositoryProvider).updateSettings(
                            language: session.language,
                            theme: value,
                          );
                      await ref.read(sessionControllerProvider.notifier).updatePreferences(
                            theme: value,
                            language: session.language,
                          );
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: session.language,
                    decoration: const InputDecoration(labelText: 'Language'),
                    items: const [
                      DropdownMenuItem(value: 'az', child: Text('Azerbaijani')),
                      DropdownMenuItem(value: 'ru', child: Text('Russian')),
                      DropdownMenuItem(value: 'en', child: Text('English')),
                    ],
                    onChanged: (value) async {
                      if (value == null) return;
                      await ref.read(profileRepositoryProvider).updateSettings(
                            language: value,
                            theme: session.theme,
                          );
                      await ref.read(sessionControllerProvider.notifier).updatePreferences(
                            theme: session.theme,
                            language: value,
                          );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

