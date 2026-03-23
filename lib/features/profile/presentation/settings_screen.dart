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

    Future<void> saveSettings({required String language, required String theme}) async {
      await ref.read(profileRepositoryProvider).updateSettings(language: language, theme: theme);
      await ref.read(sessionControllerProvider.notifier).updatePreferences(theme: theme, language: language);
    }

    return LexiconScaffold(
      title: 'Tenzimlemeler',
      fallbackRoute: '/home',
      child: ListView(
        children: [
          const _SectionLabel('DIL'),
          const SizedBox(height: 10),
          _SettingsCard(
            children: [
              _OptionTile(
                title: 'Azerbaycan dili',
                selected: session.language == 'az',
                onTap: () => saveSettings(language: 'az', theme: session.theme),
              ),
              _OptionTile(
                title: 'Russian',
                selected: session.language == 'ru',
                onTap: () => saveSettings(language: 'ru', theme: session.theme),
              ),
              _OptionTile(
                title: 'English',
                selected: session.language == 'en',
                onTap: () => saveSettings(language: 'en', theme: session.theme),
                isLast: true,
              ),
            ],
          ),
          const SizedBox(height: 24),
          const _SectionLabel('TEMA'),
          const SizedBox(height: 10),
          _SettingsCard(
            children: [
              _OptionTile(
                title: 'Light',
                selected: session.theme == 'light',
                icon: Icons.light_mode_rounded,
                onTap: () => saveSettings(language: session.language, theme: 'light'),
              ),
              _OptionTile(
                title: 'Dark',
                selected: session.theme == 'dark',
                icon: Icons.dark_mode_rounded,
                onTap: () => saveSettings(language: session.language, theme: 'dark'),
              ),
              _OptionTile(
                title: 'System',
                selected: session.theme == 'system',
                icon: Icons.settings_suggest_rounded,
                onTap: () => saveSettings(language: session.language, theme: 'system'),
                isLast: true,
              ),
            ],
          ),
          const SizedBox(height: 28),
          FilledButton.icon(
            onPressed: () => ref.read(sessionControllerProvider.notifier).signOut(),
            style: FilledButton.styleFrom(backgroundColor: Colors.red.withValues(alpha: 0.18), foregroundColor: Colors.redAccent),
            icon: const Icon(Icons.logout_rounded),
            label: const Text('Cixis et'),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.1),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(children: children),
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.title,
    required this.selected,
    required this.onTap,
    this.icon,
    this.isLast = false,
  });

  final String title;
  final bool selected;
  final VoidCallback onTap;
  final IconData? icon;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF2563EB);
    const textPrimary = Color(0xFFF1F5F9);
    const textSecondary = Color(0xFF94A3B8);

    return Column(
      children: [
        ListTile(
          onTap: onTap,
          leading: icon == null ? null : Icon(icon, color: selected ? primary : textSecondary),
          title: Text(
            title,
            style: TextStyle(color: selected ? textPrimary : textSecondary, fontWeight: selected ? FontWeight.w700 : FontWeight.w500),
          ),
          trailing: Radio<bool>(value: true, groupValue: selected, onChanged: (_) => onTap(), activeColor: primary),
        ),
        if (!isLast) const Divider(height: 1, color: Color(0xFF334155)),
      ],
    );
  }
}

