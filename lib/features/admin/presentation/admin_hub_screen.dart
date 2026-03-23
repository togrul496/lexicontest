import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/widgets/lexicon_scaffold.dart';

class AdminHubScreen extends StatelessWidget {
  const AdminHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      ('Users', AppRoutes.adminUsers.path),
      ('Pending approvals', AppRoutes.adminPending.path),
      ('Statistics', AppRoutes.adminStatistics.path),
      ('Lessons', AppRoutes.adminLessons.path),
      ('Dictionary', AppRoutes.adminDictionary.path),
      ('Notifications', AppRoutes.adminNotifications.path),
      ('Import', AppRoutes.adminImport.path),
      ('Quiz templates', AppRoutes.adminQuizTests.path),
      ('Quiz sessions', AppRoutes.adminQuizSessions.path),
    ];
    return LexiconScaffold(
      title: 'Admin Panel',
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 260,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.15,
        ),
        itemCount: items.length,
        itemBuilder: (_, index) {
          final item = items[index];
          return Card(
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: () => context.go(item.$2),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(item.$1, style: Theme.of(context).textTheme.titleLarge, textAlign: TextAlign.center),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
