import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/lexicon_scaffold.dart';
import '../data/notifications_repository.dart';

class NotificationDetailScreen extends ConsumerStatefulWidget {
  const NotificationDetailScreen({super.key, required this.notificationId});

  final int notificationId;

  @override
  ConsumerState<NotificationDetailScreen> createState() => _NotificationDetailScreenState();
}

class _NotificationDetailScreenState extends ConsumerState<NotificationDetailScreen> {
  @override
  void initState() {
    super.initState();
    Future<void>.microtask(() async {
      await ref.read(notificationsRepositoryProvider).markRead(widget.notificationId);
      ref.invalidate(notificationsProvider);
      ref.invalidate(notificationProvider(widget.notificationId));
    });
  }

  @override
  Widget build(BuildContext context) {
    final notification = ref.watch(notificationProvider(widget.notificationId));
    return LexiconScaffold(
      title: 'Notification Detail',
      child: AsyncValueView(
        value: notification,
        data: (item) => ListView(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.title, style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: 12),
                    Text(item.adminFullName.isEmpty ? 'Admin update' : item.adminFullName),
                    const SizedBox(height: 8),
                    Text(DateFormat.yMMMMd().add_Hm().format(DateTime.tryParse(item.createdAt)?.toLocal() ?? DateTime.now())),
                    const SizedBox(height: 20),
                    Text(item.body ?? item.content),
                    const SizedBox(height: 20),
                    FilledButton.icon(
                      onPressed: () async {
                        await ref.read(notificationsRepositoryProvider).toggleLike(
                              id: item.notificationId,
                              isLiked: item.isLiked,
                            );
                        ref.invalidate(notificationProvider(widget.notificationId));
                        ref.invalidate(notificationsProvider);
                      },
                      icon: Icon(item.isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded),
                      label: Text(item.isLiked ? 'Unlike' : 'Like (${item.likeCount})'),
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
