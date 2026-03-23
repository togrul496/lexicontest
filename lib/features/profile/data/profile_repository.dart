import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/models/app_models.dart';
import '../../../core/network/api_client.dart';

final profileRepositoryProvider = Provider<ProfileRepository>(
  (ref) => ProfileRepository(ref.watch(authenticatedDioProvider)),
);

final profileProvider = FutureProvider<UserProfile>((ref) async {
  return ref.watch(profileRepositoryProvider).fetchProfile();
});

class ProfileRepository {
  ProfileRepository(this._dio);

  final Dio _dio;

  Future<UserProfile> fetchProfile() async {
    final response = await _dio.get<dynamic>('api/profile/');
    return unwrapEnvelope(
      response,
      (json) => UserProfile.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<UserProfile> updateProfile({
    required String name,
    required String surname,
    required String username,
    required String email,
  }) async {
    final response = await _dio.put<dynamic>(
      'api/profile/',
      data: {
        'name': name,
        'surname': surname,
        'username': username,
        'email': email,
      },
    );
    return unwrapEnvelope(
      response,
      (json) => UserProfile.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<void> updateSettings({required String language, required String theme}) async {
    await _dio.put<dynamic>(
      'api/auth/settings',
      data: {
        'language': language,
        'theme': theme,
      },
    );
  }

  Future<String> uploadAvatar(XFile file) async {
    final formData = FormData.fromMap({
      'avatar': await MultipartFile.fromFile(file.path, filename: file.name),
    });
    final response = await _dio.post<dynamic>('api/profile/avatar', data: formData);
    final data = unwrapEnvelope<Map<String, dynamic>>(
      response,
      (json) => json as Map<String, dynamic>,
    );
    return data['avatar_url']?.toString() ?? '';
  }
}

