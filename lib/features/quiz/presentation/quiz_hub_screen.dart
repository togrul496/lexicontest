import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/widgets/lexicon_scaffold.dart';

class QuizHubScreen extends StatelessWidget {
  const QuizHubScreen({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final actions = [
      ('Open sessions', AppRoutes.quizSessions.path),
      ('Take sample', AppRoutes.takeQuiz.path.replaceFirst(':sessionId', '1')),
      ('View sample result', AppRoutes.quizResult.path.replaceFirst(':sessionId', '1')),
    ];
    return LexiconScaffold(
      title: title,
      fallbackRoute: '/home',
      child: ListView.separated(
        itemCount: actions.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, index) {
          final action = actions[index];
          return Card(
            child: ListTile(
              title: Text(action.$1),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => context.push(action.$2),
            ),
          );
        },
      ),
    );
  }
}

