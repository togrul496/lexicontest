import 'package:flutter_test/flutter_test.dart';
import 'package:lexicon_flutter/core/models/app_models.dart';
import 'package:lexicon_flutter/core/routing/app_routes.dart';

void main() {
  test('anonymous users are sent to login for protected routes', () {
    const session = AppSession(isReady: true, isAuthenticated: false);

    expect(redirectForSession(session, AppRoutes.home.path), AppRoutes.login.path);
    expect(redirectForSession(session, AppRoutes.login.path), isNull);
  });

  test('anonymous users leave splash for login once startup is ready', () {
    const session = AppSession(isReady: true, isAuthenticated: false);

    expect(redirectForSession(session, AppRoutes.splash.path), AppRoutes.login.path);
  });

  test('authenticated users leave splash for home', () {
    const session = AppSession(
      isReady: true,
      isAuthenticated: true,
      token: 'token',
      user: UserProfile(
        id: 1,
        username: 'demo',
        email: 'demo@example.com',
        role: 'student',
        status: 'active',
        language: 'az',
        theme: 'system',
      ),
    );

    expect(redirectForSession(session, AppRoutes.splash.path), AppRoutes.home.path);
  });

  test('pending users stay on pending screen', () {
    const session = AppSession(
      isReady: true,
      isAuthenticated: true,
      token: 'token',
      user: UserProfile(
        id: 1,
        username: 'demo',
        email: 'demo@example.com',
        role: 'student',
        status: 'pending',
        language: 'az',
        theme: 'system',
      ),
    );

    expect(redirectForSession(session, AppRoutes.home.path), AppRoutes.pending.path);
    expect(redirectForSession(session, AppRoutes.pending.path), isNull);
  });

  test('non-admin users cannot enter admin routes', () {
    const session = AppSession(
      isReady: true,
      isAuthenticated: true,
      token: 'token',
      user: UserProfile(
        id: 1,
        username: 'demo',
        email: 'demo@example.com',
        role: 'student',
        status: 'active',
        language: 'az',
        theme: 'system',
      ),
    );

    expect(redirectForSession(session, AppRoutes.adminRoot.path), AppRoutes.home.path);
  });
}

