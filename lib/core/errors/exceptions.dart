/// Base exception class for the application
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;
  final StackTrace? stackTrace;

  const AppException({
    required this.message,
    this.code,
    this.originalError,
    this.stackTrace,
  });

  @override
  String toString() {
    if (code != null) {
      return 'AppException [$code]: $message';
    }
    return 'AppException: $message';
  }
}

/// Network related exceptions
class NetworkException extends AppException {
  const NetworkException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  factory NetworkException.noConnection() {
    return const NetworkException(
      message: 'No internet connection available',
      code: 'NO_CONNECTION',
    );
  }

  factory NetworkException.timeout() {
    return const NetworkException(
      message: 'Connection timeout',
      code: 'TIMEOUT',
    );
  }
}

/// Firebase/Firestore related exceptions
class FirestoreException extends AppException {
  const FirestoreException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  factory FirestoreException.permissionDenied() {
    return const FirestoreException(
      message: 'You do not have permission to perform this action',
      code: 'PERMISSION_DENIED',
    );
  }

  factory FirestoreException.notFound() {
    return const FirestoreException(
      message: 'The requested document was not found',
      code: 'NOT_FOUND',
    );
  }

  factory FirestoreException.alreadyExists() {
    return const FirestoreException(
      message: 'The document already exists',
      code: 'ALREADY_EXISTS',
    );
  }
}

/// Authentication related exceptions
class AuthException extends AppException {
  const AuthException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  factory AuthException.userNotFound() {
    return const AuthException(
      message: 'No user found with this email',
      code: 'USER_NOT_FOUND',
    );
  }

  factory AuthException.wrongPassword() {
    return const AuthException(
      message: 'Incorrect password',
      code: 'WRONG_PASSWORD',
    );
  }

  factory AuthException.emailAlreadyInUse() {
    return const AuthException(
      message: 'An account already exists with this email',
      code: 'EMAIL_ALREADY_IN_USE',
    );
  }

  factory AuthException.weakPassword() {
    return const AuthException(
      message: 'The password is too weak',
      code: 'WEAK_PASSWORD',
    );
  }

  factory AuthException.invalidEmail() {
    return const AuthException(
      message: 'The email address is invalid',
      code: 'INVALID_EMAIL',
    );
  }
}

/// Validation related exceptions
class ValidationException extends AppException {
  const ValidationException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  factory ValidationException.invalidInput(String field) {
    return ValidationException(
      message: 'Invalid input for field: $field',
      code: 'INVALID_INPUT',
    );
  }

  factory ValidationException.requiredField(String field) {
    return ValidationException(
      message: 'Field is required: $field',
      code: 'REQUIRED_FIELD',
    );
  }
}

/// Cache related exceptions
class CacheException extends AppException {
  const CacheException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  factory CacheException.notFound() {
    return const CacheException(
      message: 'Data not found in cache',
      code: 'CACHE_NOT_FOUND',
    );
  }

  factory CacheException.expired() {
    return const CacheException(
      message: 'Cached data has expired',
      code: 'CACHE_EXPIRED',
    );
  }
}

/// Unknown/Unexpected exceptions
class UnknownException extends AppException {
  const UnknownException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  factory UnknownException.fromError(dynamic error) {
    return UnknownException(
      message: 'An unexpected error occurred',
      code: 'UNKNOWN',
      originalError: error,
    );
  }
}
