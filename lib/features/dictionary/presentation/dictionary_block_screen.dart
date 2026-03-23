import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/lexicon_scaffold.dart';
import '../../lessons/data/learning_repository.dart';

class DictionaryBlockScreen extends ConsumerStatefulWidget {
  const DictionaryBlockScreen({super.key, required this.blockId});

  final int blockId;

  @override
  ConsumerState<DictionaryBlockScreen> createState() => _DictionaryBlockScreenState();
}

class _DictionaryBlockScreenState extends ConsumerState<DictionaryBlockScreen> {
  late final FlutterTts _tts;

  @override
  void initState() {
    super.initState();
    _tts = FlutterTts()..setLanguage('en-US');
  }

  Future<void> _speak(String word) async {
    await _tts.stop();
    await _tts.speak(word);
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final block = ref.watch(dictionaryBlockProvider(widget.blockId));
    return LexiconScaffold(
      title: 'Vocabulary Block',
      child: AsyncValueView(
        value: block,
        data: (response) => ListView.separated(
          itemCount: response.words.length + 1,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (_, index) {
            if (index == 0) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(response.block.displayTitle, style: Theme.of(context).textTheme.headlineMedium),
                      const SizedBox(height: 8),
                      Text(response.block.description ?? 'Study the words, listen to pronunciation, and track progress.'),
                    ],
                  ),
                ),
              );
            }
            final word = response.words[index - 1];
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(word.englishWord, style: Theme.of(context).textTheme.titleLarge),
                        ),
                        IconButton(
                          onPressed: () => _speak(word.englishWord),
                          icon: const Icon(Icons.volume_up_rounded),
                        ),
                        IconButton(
                          onPressed: () async {
                            await ref.read(learningRepositoryProvider).toggleFavorite(word.id);
                            ref.invalidate(dictionaryBlockProvider(widget.blockId));
                          },
                          icon: Icon(word.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded),
                        ),
                      ],
                    ),
                    Text(word.translation),
                    if (word.transcription != null) ...[
                      const SizedBox(height: 6),
                      Text(word.transcription!),
                    ],
                    if (word.example != null) ...[
                      const SizedBox(height: 10),
                      Text(word.example!),
                    ],
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: () async {
                        await ref.read(learningRepositoryProvider).toggleLearn(word.id);
                        ref.invalidate(dictionaryBlockProvider(widget.blockId));
                      },
                      icon: Icon(word.isLearned ? Icons.check_circle_rounded : Icons.check_circle_outline_rounded),
                      label: Text(word.isLearned ? 'Learned' : 'Mark learned'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
