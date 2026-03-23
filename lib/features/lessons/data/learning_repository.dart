import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/app_models.dart';
import '../../../core/network/api_client.dart';

final learningRepositoryProvider = Provider<LearningRepository>(
  (ref) => LearningRepository(ref.watch(authenticatedDioProvider)),
);

final lessonsProvider = FutureProvider<List<Lesson>>((ref) async {
  return ref.watch(learningRepositoryProvider).fetchLessons();
});

final lessonProvider = FutureProvider.family<Lesson, int>((ref, lessonId) async {
  return ref.watch(learningRepositoryProvider).fetchLesson(lessonId);
});

final dictionaryBlocksProvider = FutureProvider<List<DayBlock>>((ref) async {
  return ref.watch(learningRepositoryProvider).fetchBlocks();
});

final dictionaryBlockProvider = FutureProvider.family<BlockWordsResponse, int>((ref, blockId) async {
  return ref.watch(learningRepositoryProvider).fetchBlockWords(blockId);
});

class LearningRepository {
  LearningRepository(this._dio);

  final Dio _dio;

  Future<List<Lesson>> fetchLessons() async {
    final response = await _dio.get<dynamic>('api/lessons/');
    return unwrapEnvelope(
      response,
      (json) => (json as List<dynamic>)
          .map((item) => Lesson.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Future<Lesson> fetchLesson(int id) async {
    final response = await _dio.get<dynamic>('api/lessons/$id');
    return unwrapEnvelope(response, (json) => Lesson.fromJson(json as Map<String, dynamic>));
  }

  Future<void> completeLesson(int id) async {
    await _dio.post<dynamic>('api/lessons/$id/complete');
  }

  Future<List<DayBlock>> fetchBlocks() async {
    final response = await _dio.get<dynamic>('api/dictionary/blocks');
    return unwrapEnvelope(
      response,
      (json) => (json as List<dynamic>)
          .map((item) => DayBlock.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Future<BlockWordsResponse> fetchBlockWords(int id) async {
    final response = await _dio.get<dynamic>('api/dictionary/blocks/$id/words');
    return unwrapEnvelope(
      response,
      (json) => BlockWordsResponse.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<void> toggleLearn(int wordId) async {
    await _dio.post<dynamic>('api/dictionary/words/$wordId/learned');
  }

  Future<void> toggleFavorite(int wordId) async {
    await _dio.post<dynamic>('api/dictionary/words/$wordId/favorite');
  }
}

