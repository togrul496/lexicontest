import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/lexicon_scaffold.dart';
import '../data/learning_repository.dart';

class LessonDetailScreen extends ConsumerWidget {
  const LessonDetailScreen({super.key, required this.lessonId});

  final int lessonId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lesson = ref.watch(lessonProvider(lessonId));
    return LexiconScaffold(
      title: 'Lesson Detail',
      child: AsyncValueView(
        value: lesson,
        data: (item) => ListView(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.title, style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: 12),
                    if (item.description != null) Text(item.description!),
                    if (item.htmlUrl != null || item.htmlFile != null) ...[
                      const SizedBox(height: 16),
                      MarkdownBody(
                        data: 'HTML source is available for this lesson.\n\n- `html_url`: ${item.htmlUrl ?? '-'}\n- `html_file`: ${item.htmlFile ?? '-'}',
                      ),
                    ],
                    const SizedBox(height: 20),
                    FilledButton.icon(
                      onPressed: () async {
                        await ref.read(learningRepositoryProvider).completeLesson(item.id);
                        ref.invalidate(lessonProvider(lessonId));
                        ref.invalidate(lessonsProvider);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Lesson marked complete')),
                          );
                        }
                      },
                      icon: const Icon(Icons.check_rounded),
                      label: Text(item.isCompleted ? 'Refresh status' : 'Complete lesson'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
