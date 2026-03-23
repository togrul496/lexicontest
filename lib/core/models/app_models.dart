class ApiEnvelope<T> {
  const ApiEnvelope({
    required this.success,
    this.data,
    this.message,
    this.error,
  });

  final bool success;
  final T? data;
  final String? message;
  final ApiError? error;

  factory ApiEnvelope.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromData,
  ) {
    return ApiEnvelope<T>(
      success: json['success'] == true,
      data: json['data'] == null ? null : fromData(json['data']),
      message: json['message'] as String?,
      error: json['error'] == null
          ? null
          : ApiError.fromJson(json['error'] as Map<String, dynamic>),
    );
  }
}

class ApiError {
  const ApiError({required this.code, required this.message});

  final String code;
  final String message;

  factory ApiError.fromJson(Map<String, dynamic> json) {
    return ApiError(
      code: json['code']?.toString() ?? 'unknown',
      message: json['message']?.toString() ?? 'Unknown error',
    );
  }
}

class UserProfile {
  const UserProfile({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
    required this.status,
    required this.language,
    required this.theme,
    this.fullName,
    this.name,
    this.surname,
    this.profileImage,
  });

  final int id;
  final String username;
  final String email;
  final String role;
  final String status;
  final String language;
  final String theme;
  final String? fullName;
  final String? name;
  final String? surname;
  final String? profileImage;

  String get displayName =>
      fullName?.trim().isNotEmpty == true ? fullName!.trim() : username;

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: (json['id'] as num?)?.toInt() ?? 0,
      username: json['username']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      role: json['role']?.toString() ?? 'student',
      status: json['status']?.toString() ?? 'pending',
      language: json['language']?.toString() ?? 'az',
      theme: json['theme']?.toString() ?? 'system',
      fullName: json['full_name']?.toString(),
      name: json['name']?.toString(),
      surname: json['surname']?.toString(),
      profileImage: json['profile_image']?.toString(),
    );
  }
}

class LoginResult {
  const LoginResult({required this.token, required this.user});

  final String token;
  final UserProfile user;

  factory LoginResult.fromJson(Map<String, dynamic> json) {
    return LoginResult(
      token: json['token']?.toString() ?? '',
      user: UserProfile.fromJson(json['user'] as Map<String, dynamic>),
    );
  }
}

class Lesson {
  const Lesson({
    required this.id,
    required this.title,
    required this.orderIndex,
    required this.isPublished,
    this.description,
    this.htmlUrl,
    this.htmlFile,
    this.isCompleted = false,
    this.videoCount = 0,
  });

  final int id;
  final String title;
  final int orderIndex;
  final bool isPublished;
  final String? description;
  final String? htmlUrl;
  final String? htmlFile;
  final bool isCompleted;
  final int videoCount;

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString(),
      htmlUrl: json['html_url']?.toString(),
      htmlFile: json['html_file']?.toString(),
      orderIndex: (json['order_index'] as num?)?.toInt() ?? 0,
      isPublished: json['is_published'] == true,
      isCompleted: json['is_completed'] == true,
      videoCount: (json['video_count'] as num?)?.toInt() ?? 0,
    );
  }
}

class DayBlock {
  const DayBlock({
    required this.id,
    required this.dayNumber,
    this.title,
    this.description,
    this.totalWords = 0,
    this.learnedWords = 0,
    this.blockType = 'daily',
  });

  final int id;
  final int dayNumber;
  final String? title;
  final String? description;
  final int totalWords;
  final int learnedWords;
  final String blockType;

  String get displayTitle => title?.isNotEmpty == true ? title! : 'Day $dayNumber';

  factory DayBlock.fromJson(Map<String, dynamic> json) {
    return DayBlock(
      id: (json['id'] as num?)?.toInt() ?? 0,
      dayNumber: (json['day_number'] as num?)?.toInt() ?? 0,
      title: json['title']?.toString(),
      description: json['description']?.toString(),
      totalWords: (json['total_words'] as num?)?.toInt() ?? 0,
      learnedWords: (json['learned_words'] as num?)?.toInt() ?? 0,
      blockType: json['block_type']?.toString() ?? 'daily',
    );
  }
}

class WordItem {
  const WordItem({
    required this.id,
    required this.englishWord,
    required this.translation,
    this.transcription,
    this.example,
    this.audioUrl,
    this.isLearned = false,
    this.isFavorite = false,
  });

  final int id;
  final String englishWord;
  final String translation;
  final String? transcription;
  final String? example;
  final String? audioUrl;
  final bool isLearned;
  final bool isFavorite;

  factory WordItem.fromJson(Map<String, dynamic> json) {
    return WordItem(
      id: (json['id'] as num?)?.toInt() ?? 0,
      englishWord: json['english_word']?.toString() ?? '',
      translation: json['translation']?.toString() ?? '',
      transcription: json['transcription']?.toString(),
      example: json['example']?.toString(),
      audioUrl: json['audio_url']?.toString(),
      isLearned: json['is_learned'] == true || json['is_learned'] == 1,
      isFavorite: json['is_favorite'] == true || json['is_favorite'] == 1,
    );
  }
}

class BlockWordsResponse {
  const BlockWordsResponse({required this.block, required this.words});

  final DayBlock block;
  final List<WordItem> words;

  factory BlockWordsResponse.fromJson(Map<String, dynamic> json) {
    return BlockWordsResponse(
      block: DayBlock.fromJson(json['block'] as Map<String, dynamic>),
      words: (json['words'] as List<dynamic>? ?? const [])
          .map((item) => WordItem.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class NotificationItem {
  const NotificationItem({
    required this.notificationId,
    required this.title,
    required this.content,
    required this.type,
    required this.createdAt,
    this.userNotifId = 0,
    this.body,
    this.adminFullName = '',
    this.adminAvatar,
    this.isRead = false,
    this.isLiked = false,
    this.likeCount = 0,
  });

  final int notificationId;
  final int userNotifId;
  final String title;
  final String content;
  final String type;
  final String createdAt;
  final String? body;
  final String adminFullName;
  final String? adminAvatar;
  final bool isRead;
  final bool isLiked;
  final int likeCount;

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      notificationId: (json['notification_id'] as num?)?.toInt() ?? 0,
      userNotifId: (json['user_notif_id'] as num?)?.toInt() ?? 0,
      title: json['title']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      body: json['body']?.toString(),
      type: json['type']?.toString() ?? 'general',
      createdAt: json['created_at']?.toString() ?? '',
      adminFullName: json['admin_full_name']?.toString() ?? '',
      adminAvatar: json['admin_avatar']?.toString(),
      isRead: json['is_read'] == true || json['is_read'] == 1,
      isLiked: json['is_liked'] == true || json['is_liked'] == 1,
      likeCount: (json['like_count'] as num?)?.toInt() ?? 0,
    );
  }
}

class AppSession {
  const AppSession({
    required this.isReady,
    required this.isAuthenticated,
    this.token,
    this.user,
    this.theme = 'system',
    this.language = 'az',
  });

  final bool isReady;
  final bool isAuthenticated;
  final String? token;
  final UserProfile? user;
  final String theme;
  final String language;

  bool get isAdmin => user?.role == 'admin';
  bool get isPending => (user?.status ?? '') == 'pending';

  AppSession copyWith({
    bool? isReady,
    bool? isAuthenticated,
    String? token,
    UserProfile? user,
    String? theme,
    String? language,
    bool clearToken = false,
    bool clearUser = false,
  }) {
    return AppSession(
      isReady: isReady ?? this.isReady,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      token: clearToken ? null : token ?? this.token,
      user: clearUser ? null : user ?? this.user,
      theme: theme ?? this.theme,
      language: language ?? this.language,
    );
  }

  static const empty = AppSession(isReady: false, isAuthenticated: false);
}
