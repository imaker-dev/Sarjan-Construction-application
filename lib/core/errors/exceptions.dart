class ServerException implements Exception {
  final String message;
  final int? statusCode;

  const ServerException({required this.message, this.statusCode});

  @override
  String toString() => 'ServerException: $message (code: $statusCode)';
}

class CacheException implements Exception {
  final String message;

  const CacheException({required this.message});

  @override
  String toString() => 'CacheException: $message';
}

class UnauthorizedException implements Exception {
  final String message;

  const UnauthorizedException({this.message = 'Session expired or invalid credentials'});

  @override
  String toString() => 'UnauthorizedException: $message';
}
