import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/lexicon_scaffold.dart';
import '../../lessons/data/learning_repository.dart';

class DictionaryScreen extends ConsumerWidget {
  const DictionaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blocks = ref.watch(dictionaryBlocksProvider);
    return LexiconScaffold(
      title: 'Lugat',
      fallbackRoute: '/home',
      child: AsyncValueView(
        value: blocks,
        data: (items) => GridView.builder(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 320,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.2,
          ),
          itemCount: items.length,
          itemBuilder: (_, index) {
            final block = items[index];
            return Card(
              child: InkWell(
                borderRadius: BorderRadius.circular(24),
                onTap: () => context.push('/dictionary/block/${block.id}'),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Chip(label: Text(block.blockType.toUpperCase())),
                      const Spacer(),
                      Text(block.displayTitle, style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 8),
                      Text('${block.learnedWords}/${block.totalWords} soz oyrenilib'),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

