import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:lexicon_flutter/features/admin/presentation/admin_hub_screen.dart';
import 'package:lexicon_flutter/features/auth/data/auth_repository.dart';
import 'package:lexicon_flutter/features/auth/presentation/login_screen.dart';
import 'package:lexicon_flutter/features/auth/presentation/pending_approval_screen.dart';
import 'package:lexicon_flutter/features/auth/presentation/register_screen.dart';
import 'package:lexicon_flutter/features/auth/presentation/splash_screen.dart';
import 'package:lexicon_flutter/features/dashboard/presentation/home_screen.dart';
import 'package:lexicon_flutter/features/dictionary/presentation/dictionary_block_screen.dart';
import 'package:lexicon_flutter/features/dictionary/presentation/dictionary_screen.dart';
import 'package:lexicon_flutter/features/lessons/presentation/lesson_detail_screen.dart';
import 'package:lexicon_flutter/features/lessons/presentation/lessons_screen.dart';
import 'package:lexicon_flutter/features/notifications/presentation/notification_detail_screen.dart';
import 'package:lexicon_flutter/features/notifications/presentation/notifications_screen.dart';
import 'package:lexicon_flutter/features/profile/presentation/profile_screen.dart';
import 'package:lexicon_flutter/features/profile/presentation/settings_screen.dart';
import 'package:lexicon_flutter/features/quiz/presentation/quiz_hub_screen.dart';
import 'package:lexicon_flutter/features/tests/presentation/feature_placeholder_screen.dart';
import 'package:lexicon_flutter/features/tests/presentation/tests_hub_screen.dart';
import 'package:lexicon_flutter/core/models/app_models.dart';

class AppRouteDef {
  const AppRouteDef(this.name, this.path);

  final String name;
  final String path;
}

abstract final class AppRoutes {
  static const splash = AppRouteDef('splash', '/');
  static const login = AppRouteDef('login', '/login');
  static const register = AppRouteDef('register', '/register');
  static const pending = AppRouteDef('pending', '/pending');
  static const home = AppRouteDef('home', '/home');
  static const lessons = AppRouteDef('lessons', '/lessons');
  static const lessonDetail = AppRouteDef('lesson-detail', '/lessons/:lessonId');
  static const dictionary = AppRouteDef('dictionary', '/dictionary');
  static const dictionaryBlock = AppRouteDef('dictionary-block', '/dictionary/block/:blockId');
  static const blockTest = AppRouteDef('block-test', '/dictionary/block/:blockId/test');
  static const tests = AppRouteDef('tests', '/tests');
  static const testPassing = AppRouteDef('test-passing', '/tests/:testId');
  static const onlineTests = AppRouteDef('online-tests', '/online-tests');
  static const onlineTestDetail = AppRouteDef('online-test-detail', '/online-tests/:testId');
  static const progress = AppRouteDef('progress', '/progress');
  static const notifications = AppRouteDef('notifications', '/notifications');
  static const notificationDetail = AppRouteDef('notification-detail', '/notifications/:notifId');
  static const settings = AppRouteDef('settings', '/settings');
  static const profile = AppRouteDef('profile', '/profile');
  static const latestResults = AppRouteDef('latest-results', '/online-tests/latest/results');
  static const quizSessions = AppRouteDef('quiz-sessions', '/quiz/sessions');
  static const takeQuiz = AppRouteDef('take-quiz', '/quiz/sessions/:sessionId/take');
  static const quizResult = AppRouteDef('quiz-result', '/quiz/sessions/:sessionId/result');
  static const adminRoot = AppRouteDef('admin', '/admin');
  static const adminProfile = AppRouteDef('admin-profile', '/admin/profile');
  static const adminUsers = AppRouteDef('admin-users', '/admin/users');
  static const adminUserDetail = AppRouteDef('admin-user-detail', '/admin/users/:userId');
  static const adminPending = AppRouteDef('admin-pending', '/admin/pending');
  static const adminStatistics = AppRouteDef('admin-statistics', '/admin/statistics');
  static const adminLessons = AppRouteDef('admin-lessons', '/admin/lessons');
  static const adminLessonEdit = AppRouteDef('admin-lesson-edit', '/admin/lessons/:lessonId/edit');
  static const adminLessonPreview = AppRouteDef('admin-lesson-preview', '/admin/lessons/:lessonId/preview');
  static const adminDictionary = AppRouteDef('admin-dictionary', '/admin/dictionary');
  static const adminDictionaryBlock = AppRouteDef('admin-dictionary-block', '/admin/dictionary/block/:blockId');
  static const adminBlockResults = AppRouteDef('admin-block-results', '/admin/dictionary/block/:blockId/results');
  static const adminTests = AppRouteDef('admin-tests', '/admin/tests');
  static const adminOnlineTests = AppRouteDef('admin-online-tests', '/admin/online-tests');
  static const adminNotifications = AppRouteDef('admin-notifications', '/admin/notifications');
  static const adminNotificationCreate = AppRouteDef('admin-notification-create', '/admin/notifications/create');
  static const adminNotificationEdit = AppRouteDef('admin-notification-edit', '/admin/notifications/:notifId/edit');
  static const adminNotificationStats = AppRouteDef('admin-notification-stats', '/admin/notifications/:notifId/stats');
  static const adminImport = AppRouteDef('admin-import', '/admin/import');
  static const adminQuizTests = AppRouteDef('admin-quiz-tests', '/admin/quiz/tests');
  static const adminQuizCreate = AppRouteDef('admin-quiz-create', '/admin/quiz/tests/create');
  static const adminQuizEdit = AppRouteDef('admin-quiz-edit', '/admin/quiz/tests/:testId/edit');
  static const adminQuizSessions = AppRouteDef('admin-quiz-sessions', '/admin/quiz/sessions');
  static const adminQuizSessionResults = AppRouteDef('admin-quiz-session-results', '/admin/quiz/sessions/:sessionId/results');
}

String? redirectForSession(AppSession session, String location) {
  const publicAuthPaths = {'/login', '/register'};
  final isSplash = location == AppRoutes.splash.path;

  if (!session.isReady) {
    return isSplash ? null : AppRoutes.splash.path;
  }

  if (!session.isAuthenticated) {
    return publicAuthPaths.contains(location) ? null : AppRoutes.login.path;
  }

  if (session.isPending) {
    return location == AppRoutes.pending.path ? null : AppRoutes.pending.path;
  }

  if (isSplash || publicAuthPaths.contains(location) || location == AppRoutes.pending.path) {
    return session.isAdmin ? AppRoutes.adminRoot.path : AppRoutes.home.path;
  }

  if (!session.isAdmin && location.startsWith('/admin')) {
    return AppRoutes.home.path;
  }

  return null;
}

final routerProvider = Provider<GoRouter>((ref) {
  final session = ref.watch(sessionControllerProvider);
  return GoRouter(
    initialLocation: AppRoutes.splash.path,
    redirect: (_, state) => redirectForSession(session, state.matchedLocation),
    routes: [
      GoRoute(path: AppRoutes.splash.path, name: AppRoutes.splash.name, builder: (_, __) => const SplashScreen()),
      GoRoute(path: AppRoutes.login.path, name: AppRoutes.login.name, builder: (_, __) => const LoginScreen()),
      GoRoute(path: AppRoutes.register.path, name: AppRoutes.register.name, builder: (_, __) => const RegisterScreen()),
      GoRoute(path: AppRoutes.pending.path, name: AppRoutes.pending.name, builder: (_, __) => const PendingApprovalScreen()),
      GoRoute(path: AppRoutes.home.path, name: AppRoutes.home.name, builder: (_, __) => const HomeScreen()),
      GoRoute(path: AppRoutes.lessons.path, name: AppRoutes.lessons.name, builder: (_, __) => const LessonsScreen()),
      GoRoute(path: AppRoutes.lessonDetail.path, name: AppRoutes.lessonDetail.name, builder: (_, state) => LessonDetailScreen(lessonId: int.parse(state.pathParameters['lessonId']!))),
      GoRoute(path: AppRoutes.dictionary.path, name: AppRoutes.dictionary.name, builder: (_, __) => const DictionaryScreen()),
      GoRoute(path: AppRoutes.dictionaryBlock.path, name: AppRoutes.dictionaryBlock.name, builder: (_, state) => DictionaryBlockScreen(blockId: int.parse(state.pathParameters['blockId']!))),
      GoRoute(path: AppRoutes.blockTest.path, name: AppRoutes.blockTest.name, builder: (_, state) => FeaturePlaceholderScreen(title: 'Block Test', subtitle: 'Assessment flow and result submission migrate next.', routeLabel: state.matchedLocation)),
      GoRoute(path: AppRoutes.tests.path, name: AppRoutes.tests.name, builder: (_, __) => const TestsHubScreen()),
      GoRoute(path: AppRoutes.testPassing.path, name: AppRoutes.testPassing.name, builder: (_, state) => FeaturePlaceholderScreen(title: 'Standard Test', subtitle: 'Interactive question flow will plug into the shared test engine.', routeLabel: state.matchedLocation)),
      GoRoute(path: AppRoutes.onlineTests.path, name: AppRoutes.onlineTests.name, builder: (_, __) => const QuizHubScreen(title: 'Online Tests')),
      GoRoute(path: AppRoutes.onlineTestDetail.path, name: AppRoutes.onlineTestDetail.name, builder: (_, state) => FeaturePlaceholderScreen(title: 'Online Test Detail', subtitle: 'Registration, countdown, and leaderboard migration follows the shared quiz stack.', routeLabel: state.matchedLocation)),
      GoRoute(path: AppRoutes.progress.path, name: AppRoutes.progress.name, builder: (_, state) => const FeaturePlaceholderScreen(title: 'Progress', subtitle: 'Charts and progress analytics are routed and ready for the next pass.', routeLabel: '/progress')),
      GoRoute(path: AppRoutes.notifications.path, name: AppRoutes.notifications.name, builder: (_, __) => const NotificationsScreen()),
      GoRoute(path: AppRoutes.notificationDetail.path, name: AppRoutes.notificationDetail.name, builder: (_, state) => NotificationDetailScreen(notificationId: int.parse(state.pathParameters['notifId']!))),
      GoRoute(path: AppRoutes.settings.path, name: AppRoutes.settings.name, builder: (_, __) => const SettingsScreen()),
      GoRoute(path: AppRoutes.profile.path, name: AppRoutes.profile.name, builder: (_, __) => const ProfileScreen()),
      GoRoute(path: AppRoutes.latestResults.path, name: AppRoutes.latestResults.name, builder: (_, state) => const FeaturePlaceholderScreen(title: 'Latest Results', subtitle: 'Latest-completed leaderboard presentation is reserved in the new route map.', routeLabel: '/online-tests/latest/results')),
      GoRoute(path: AppRoutes.quizSessions.path, name: AppRoutes.quizSessions.name, builder: (_, __) => const QuizHubScreen(title: 'Quiz Sessions')),
      GoRoute(path: AppRoutes.takeQuiz.path, name: AppRoutes.takeQuiz.name, builder: (_, state) => FeaturePlaceholderScreen(title: 'Take Quiz', subtitle: 'Timed quiz player is planned behind the shared quiz engine.', routeLabel: state.matchedLocation)),
      GoRoute(path: AppRoutes.quizResult.path, name: AppRoutes.quizResult.name, builder: (_, state) => FeaturePlaceholderScreen(title: 'Quiz Result', subtitle: 'Participant results and leaderboard route is fully reserved.', routeLabel: state.matchedLocation)),
      GoRoute(path: AppRoutes.adminRoot.path, name: AppRoutes.adminRoot.name, builder: (_, __) => const AdminHubScreen()),
      ..._adminPlaceholderRoutes(),
    ],
  );
});

List<RouteBase> _adminPlaceholderRoutes() {
  GoRoute simple(AppRouteDef route, String title, String subtitle) {
    return GoRoute(
      path: route.path,
      name: route.name,
      builder: (_, state) => FeaturePlaceholderScreen(
        title: title,
        subtitle: subtitle,
        routeLabel: state.matchedLocation,
      ),
    );
  }

  return [
    simple(AppRoutes.adminProfile, 'Admin Profile', 'Profile parity shares the user profile foundation.'),
    simple(AppRoutes.adminUsers, 'Admin Users', 'User moderation view is queued into the admin repository layer.'),
    simple(AppRoutes.adminUserDetail, 'Admin User Detail', 'Per-user statistics and actions are reserved here.'),
    simple(AppRoutes.adminPending, 'Admin Pending', 'Approval queue route is created for admin moderation flows.'),
    simple(AppRoutes.adminStatistics, 'Admin Statistics', 'Admin metrics and dashboards attach to this route.'),
    simple(AppRoutes.adminLessons, 'Admin Lessons', 'Lesson management is scaffolded for the next pass.'),
    simple(AppRoutes.adminLessonEdit, 'Admin Lesson Edit', 'Lesson editor migration will land on this route.'),
    simple(AppRoutes.adminLessonPreview, 'Admin Lesson Preview', 'Preview route is present for content QA.'),
    simple(AppRoutes.adminDictionary, 'Admin Dictionary', 'Dictionary management route is scaffolded.'),
    simple(AppRoutes.adminDictionaryBlock, 'Admin Block Detail', 'Admin block detail route is scaffolded.'),
    simple(AppRoutes.adminBlockResults, 'Admin Block Results', 'Block test analytics route is scaffolded.'),
    simple(AppRoutes.adminTests, 'Admin Tests', 'Standard admin tests route is scaffolded.'),
    simple(AppRoutes.adminOnlineTests, 'Admin Online Tests', 'Online test admin route is scaffolded.'),
    simple(AppRoutes.adminNotifications, 'Admin Notifications', 'Compose, publish, and stats flows land here next.'),
    simple(AppRoutes.adminNotificationCreate, 'Create Notification', 'Notification compose form route is scaffolded.'),
    simple(AppRoutes.adminNotificationEdit, 'Edit Notification', 'Notification editing route is scaffolded.'),
    simple(AppRoutes.adminNotificationStats, 'Notification Stats', 'Read/like/delivery analytics route is scaffolded.'),
    simple(AppRoutes.adminImport, 'Admin Import', 'Cross-platform file import route is scaffolded for backend-side parsing.'),
    simple(AppRoutes.adminQuizTests, 'Quiz Templates', 'Admin quiz template management route is scaffolded.'),
    simple(AppRoutes.adminQuizCreate, 'Create Quiz Template', 'Quiz template editor route is scaffolded.'),
    simple(AppRoutes.adminQuizEdit, 'Edit Quiz Template', 'Quiz template edit route is scaffolded.'),
    simple(AppRoutes.adminQuizSessions, 'Quiz Sessions', 'Admin quiz scheduling route is scaffolded.'),
    simple(AppRoutes.adminQuizSessionResults, 'Quiz Session Results', 'Admin result analytics route is scaffolded.'),
  ];
}
