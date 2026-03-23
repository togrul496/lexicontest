import 'package:flutter/material.dart';

import '../../../core/widgets/lexicon_scaffold.dart';

class FeaturePlaceholderScreen extends StatelessWidget {
  const FeaturePlaceholderScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.routeLabel,
  });

  final String title;
  final String subtitle;
  final String routeLabel;

  @override
  Widget build(BuildContext context) {
    return LexiconScaffold(
      title: title,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 12),
                  Text(subtitle),
                  const SizedBox(height: 16),
                  Text('Mapped route: $routeLabel'),
                  const SizedBox(height: 16),
                  const Text(
                    'This screen is intentionally scaffolded so the migration can ship with full route coverage while we continue replacing each Compose flow with native Flutter implementations.',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
