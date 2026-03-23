import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/lexicon_scaffold.dart';
import '../data/notifications_repository.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationsProvider);
    return LexiconScaffold(
      title: 'Bildirisler',
      fallbackRoute: '/home',
      actions: [
        IconButton(
          onPressed: () async {
            await ref.read(notificationsRepositoryProvider).markAllRead();
            ref.invalidate(notificationsProvider);
          },
          icon: const Icon(Icons.done_all_rounded),
        ),
      ],
      child: AsyncValueView(
        value: notifications,
        data: (items) => ListView.separated(
          itemCount: items.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (_, index) {
            final item = items[index];
            return Card(
              child: ListTile(
                onTap: () => context.push('/notifications/${item.notificationId}'),
                leading: CircleAvatar(
                  child: Icon(item.isRead ? Icons.mark_email_read_rounded : Icons.mark_email_unread_rounded),
                ),
                title: Text(item.title),
                subtitle: Text(
                  '${item.adminFullName.isNotEmpty ? '${item.adminFullName} • ' : ''}${DateFormat.yMMMd().add_Hm().format(DateTime.tryParse(item.createdAt)?.toLocal() ?? DateTime.now())}\n${item.content}',
                ),
                isThreeLine: true,
                trailing: item.likeCount > 0 ? Chip(label: Text('${item.likeCount}')) : const Icon(Icons.chevron_right_rounded),
              ),
            );
          },
        ),
      ),
    );
  }
}

