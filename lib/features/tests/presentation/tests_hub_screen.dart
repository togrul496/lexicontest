import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/widgets/lexicon_scaffold.dart';

class TestsHubScreen extends StatelessWidget {
  const TestsHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cards = [
      ('Standard Tests', AppRoutes.testPassing.path.replaceFirst(':testId', '1')),
      ('Online Tests', AppRoutes.onlineTests.path),
      ('Progress', AppRoutes.progress.path),
      ('Latest Results', AppRoutes.latestResults.path),
      ('Quiz Sessions', AppRoutes.quizSessions.path),
    ];
    return LexiconScaffold(
      title: 'Tests & Results',
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 320,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.15,
        ),
        itemCount: cards.length,
        itemBuilder: (_, index) {
          final card = cards[index];
          return Card(
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: () => context.go(card.$2),
              child: Center(child: Text(card.$1, style: Theme.of(context).textTheme.titleLarge)),
            ),
          );
        },
      ),
    );
  }
}
