import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/app_models.dart';
import 'api_exception.dart';
import '../../features/auth/data/auth_repository.dart';

const baseUrl = 'https://lexicon.pythonanywhere.com/';

Dio buildDio({String? token}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        if (token != null) 'Authorization': 'Bearer $token',
      },
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onError: (error, handler) {
        final data = error.response?.data;
        final message = data is Map<String, dynamic>
            ? ((data['message'] ?? data['error']?['message']) as String?)?.trim()
            : null;
        handler.reject(
          DioException(
            requestOptions: error.requestOptions,
            response: error.response,
            error: ApiException(
              message?.isNotEmpty == true ? message! : 'Network request failed',
              statusCode: error.response?.statusCode,
            ),
          ),
        );
      },
    ),
  );

  return dio;
}

final publicDioProvider = Provider<Dio>((ref) => buildDio());

final authenticatedDioProvider = Provider<Dio>((ref) {
  final token = ref.watch(sessionControllerProvider).token;
  return buildDio(token: token);
});

T unwrapEnvelope<T>(Response<dynamic> response, T Function(Object? json) mapper) {
  final raw = response.data;
  if (raw is! Map<String, dynamic>) {
    throw const ApiException('Unexpected response format');
  }
  final envelope = ApiEnvelope<T>.fromJson(raw, mapper);
  if (!envelope.success || envelope.data == null) {
    throw ApiException(
      envelope.error?.message ?? envelope.message ?? 'Request failed',
      statusCode: response.statusCode,
    );
  }
  return envelope.data as T;
}
