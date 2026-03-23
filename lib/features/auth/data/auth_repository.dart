import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/app_models.dart';
import '../../../core/network/api_client.dart';
import '../../../core/services/session_storage.dart';

final sessionStorageProvider = Provider<SessionStorage>((ref) => SessionStorage());

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(ref.watch(publicDioProvider)),
);

final sessionControllerProvider = StateNotifierProvider<SessionController, AppSession>(
  (ref) => SessionController(
    ref.watch(authRepositoryProvider),
    ref.watch(sessionStorageProvider),
  )..hydrate(),
);

class AuthRepository {
  AuthRepository(this._dio);

  final Dio _dio;

  Future<LoginResult> login({required String username, required String password}) async {
    final response = await _dio.post<dynamic>(
      'api/auth/login',
      data: {
        'username': username,
        'password': password,
        'device_id': 'flutter-mobile',
      },
    );
    return unwrapEnvelope(
      response,
      (json) => LoginResult.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<LoginResult> register({
    required String username,
    required String email,
    required String password,
    required String fullName,
  }) async {
    final response = await _dio.post<dynamic>(
      'api/auth/register',
      data: {
        'username': username,
        'email': email,
        'password': password,
        'full_name': fullName,
      },
    );
    return unwrapEnvelope(
      response,
      (json) => LoginResult.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<UserProfile> getMe() async {
    final response = await _dio.get<dynamic>('api/auth/me');
    return unwrapEnvelope(
      response,
      (json) => UserProfile.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<void> logout() async {
    try {
      await _dio.post<dynamic>('api/auth/logout');
    } catch (_) {}
  }
}

class SessionController extends StateNotifier<AppSession> {
  SessionController(this._authRepository, this._storage) : super(AppSession.empty);

  final AuthRepository _authRepository;
  final SessionStorage _storage;

  Future<void> hydrate() async {
    final stored = await _storage.load();
    if (!stored.isAuthenticated || stored.token == null) {
      state = stored;
      return;
    }

    state = stored;
    try {
      final user = await _authRepository.getMe();
      final next = stored.copyWith(
        isReady: true,
        isAuthenticated: true,
        user: user,
        theme: user.theme,
        language: user.language,
      );
      state = next;
      await _storage.saveSession(
        token: stored.token!,
        user: user,
        theme: next.theme,
        language: next.language,
      );
    } catch (_) {
      await _storage.clear();
      state = const AppSession(isReady: true, isAuthenticated: false);
    }
  }

  Future<void> signIn(LoginResult result) async {
    final next = AppSession(
      isReady: true,
      isAuthenticated: true,
      token: result.token,
      user: result.user,
      theme: result.user.theme,
      language: result.user.language,
    );
    state = next;
    await _storage.saveSession(
      token: result.token,
      user: result.user,
      theme: next.theme,
      language: next.language,
    );
  }

  Future<void> signOut() async {
    await _authRepository.logout();
    await _storage.clear();
    state = state.copyWith(
      isReady: true,
      isAuthenticated: false,
      clearToken: true,
      clearUser: true,
    );
  }

  Future<void> updateUser(UserProfile user) async {
    final next = state.copyWith(user: user, theme: user.theme, language: user.language);
    state = next;
    if (next.token != null) {
      await _storage.saveSession(
        token: next.token!,
        user: user,
        theme: next.theme,
        language: next.language,
      );
    }
  }

  Future<void> updatePreferences({required String theme, required String language}) async {
    state = state.copyWith(theme: theme, language: language);
    await _storage.savePreferences(theme: theme, language: language);
  }
}

