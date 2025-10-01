/// Firestore collection names as constants to avoid hardcoded strings
class FirestoreCollections {
  static const String contacts = 'contacts';
  static const String deals = 'deals';
  static const String tasks = 'tasks';
  static const String users = 'users';
  static const String notifications = 'notifications';
  static const String activities = 'activities';
  static const String pipelines = 'pipelines';
}

/// Firebase storage paths
class FirebaseStoragePaths {
  static const String avatars = 'avatars';
  static const String documents = 'documents';
  static const String attachments = 'attachments';
}

/// App-wide constants
class AppConstants {
  // Cache durations
  static const Duration cacheTimeout = Duration(minutes: 5);
  static const Duration shortCacheTimeout = Duration(minutes: 1);
  static const Duration longCacheTimeout = Duration(hours: 1);

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // API timeouts
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration longApiTimeout = Duration(minutes: 2);

  // Animation durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // Date formats
  static const String dateFormat = 'yyyy-MM-dd';
  static const String dateTimeFormat = 'yyyy-MM-dd HH:mm:ss';
  static const String timeFormat = 'HH:mm';
  static const String displayDateFormat = 'MMM dd, yyyy';
  static const String displayDateTimeFormat = 'MMM dd, yyyy HH:mm';
}

/// Error messages
class ErrorMessages {
  static const String networkError = 'No internet connection';
  static const String serverError = 'Server error occurred';
  static const String unknownError = 'An unexpected error occurred';
  static const String timeoutError = 'Request timeout';
  static const String permissionDenied = 'Permission denied';
  static const String notFound = 'Resource not found';
  static const String invalidInput = 'Invalid input';
  static const String requiredField = 'This field is required';
}

/// Success messages
class SuccessMessages {
  static const String contactCreated = 'Contact created successfully';
  static const String contactUpdated = 'Contact updated successfully';
  static const String contactDeleted = 'Contact deleted successfully';
  
  static const String dealCreated = 'Deal created successfully';
  static const String dealUpdated = 'Deal updated successfully';
  static const String dealDeleted = 'Deal deleted successfully';
  
  static const String taskCreated = 'Task created successfully';
  static const String taskUpdated = 'Task updated successfully';
  static const String taskDeleted = 'Task deleted successfully';
  static const String taskCompleted = 'Task completed successfully';
}
