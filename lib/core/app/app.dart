import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/data/auth_repository.dart';
import '../routing/app_routes.dart';
import '../services/notification_service.dart';
import '../theme/app_theme.dart';

final notificationServiceProvider = Provider<NotificationService>(
  (ref) => NotificationService(FlutterLocalNotificationsPlugin()),
);

class LexiconApp extends ConsumerStatefulWidget {
  const LexiconApp({super.key});

  @override
  ConsumerState<LexiconApp> createState() => _LexiconAppState();
}

class _LexiconAppState extends ConsumerState<LexiconApp> {
  @override
  void initState() {
    super.initState();
    Future<void>.microtask(() async {
      await ref.read(notificationServiceProvider).initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);
    final session = ref.watch(sessionControllerProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Lexicon Flutter',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeModeFromSetting(session.theme),
      routerConfig: router,
    );
  }
}
