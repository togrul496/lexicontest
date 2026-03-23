import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/lexicon_scaffold.dart';
import '../data/learning_repository.dart';

class LessonsScreen extends ConsumerWidget {
  const LessonsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lessons = ref.watch(lessonsProvider);
    return LexiconScaffold(
      title: 'Dersler',
      fallbackRoute: '/home',
      child: AsyncValueView(
        value: lessons,
        data: (items) => ListView.separated(
          itemCount: items.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (_, index) {
            final lesson = items[index];
            return Card(
              child: ListTile(
                title: Text(lesson.title),
                subtitle: Text(lesson.description ?? 'Structured lesson content'),
                trailing: Icon(lesson.isCompleted ? Icons.check_circle_rounded : Icons.chevron_right_rounded),
                onTap: () => context.push('/lessons/${lesson.id}'),
              ),
            );
          },
        ),
      ),
    );
  }
}

