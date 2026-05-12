class AiException implements Exception {
  const AiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  static const String invalidFeature = 'Invalid AI feature.';
  static const String usageLimitReached =
      'You have reached your AI usage limit for this feature.';
  static const String serviceUnavailable =
      'The AI service is temporarily unavailable. Please try again later.';
  static const String unauthenticated = 'Unauthenticated.';

  factory AiException.fromStatusCode(int? statusCode) {
    switch (statusCode) {
      case 400:
        return const AiException(invalidFeature, statusCode: 400);
      case 401:
        return const AiException(unauthenticated, statusCode: 401);
      case 429:
        return const AiException(usageLimitReached, statusCode: 429);
      case 500:
      default:
        return AiException(serviceUnavailable, statusCode: statusCode);
    }
  }

  @override
  String toString() => message;
}
