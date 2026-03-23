import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/widgets/lexicon_scaffold.dart';
import '../../auth/data/auth_repository.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionControllerProvider);
    final items = [
      ('Lessons', 'Continue structured content', AppRoutes.lessons.path, Icons.menu_book_rounded),
      ('Dictionary', 'Learn day-by-day vocabulary blocks', AppRoutes.dictionary.path, Icons.translate_rounded),
      ('Tests', 'Open exams, online tests, and results', AppRoutes.tests.path, Icons.fact_check_rounded),
      ('Notifications', 'Read announcements and updates', AppRoutes.notifications.path, Icons.notifications_active_rounded),
      ('Profile', 'Edit account, avatar, and preferences', AppRoutes.profile.path, Icons.person_rounded),
      ('Settings', 'Theme, language, and app behavior', AppRoutes.settings.path, Icons.tune_rounded),
    ];

    return LexiconScaffold(
      title: 'Home',
      actions: [
        IconButton(
          onPressed: () => ref.read(sessionControllerProvider.notifier).signOut(),
          icon: const Icon(Icons.logout_rounded),
        ),
      ],
      child: ListView(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Hello, ${session.user?.displayName ?? 'Learner'}', style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 12),
                  const Text(
                    'This new Flutter shell already speaks to the live backend, persists session state, and maps the full migration route tree.',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: items.map((item) {
              return SizedBox(
                width: 280,
                child: Card(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(24),
                    onTap: () => context.go(item.$3),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(item.$4, size: 30),
                          const SizedBox(height: 14),
                          Text(item.$1, style: Theme.of(context).textTheme.titleLarge),
                          const SizedBox(height: 8),
                          Text(item.$2),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          if (session.isAdmin) ...[
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => context.go(AppRoutes.adminRoot.path),
              icon: const Icon(Icons.admin_panel_settings_rounded),
              label: const Text('Open Admin Panel'),
            ),
          ],
        ],
      ),
    );
  }
}
