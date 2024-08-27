class ServerException implements Exception {
  final String message;

  ServerException([this.message = 'An error occurred while communicating with the server']);

  @override
  String toString() => 'ServerException: $message';
}

class CacheException implements Exception {
  final String message;

  CacheException([this.message = 'An error occurred while accessing the cache']);

  @override
  String toString() => 'CacheException: $message';
}

class NetworkException implements Exception {
  final String message;

  NetworkException([this.message = 'A network error occurred']);

  @override
  String toString() => 'NetworkException: $message';
}

class ValidationException implements Exception {
  final String message;

  ValidationException([this.message = 'A validation error occurred']);

  @override
  String toString() => 'ValidationException: $message';
}

class NotFoundException implements Exception {
  final String message;

  NotFoundException([this.message = 'The requested resource was not found']);

  @override
  String toString() => 'NotFoundException: $message';
}

class PurchaseException implements Exception {
  final String message;

  PurchaseException([this.message = 'An error occurred during the purchase process']);

  @override
  String toString() => 'PurchaseException: $message';
}

class AuthenticationException implements Exception {
  final String message;

  AuthenticationException([this.message = 'An authentication error occurred']);

  @override
  String toString() => 'AuthenticationException: $message';
}