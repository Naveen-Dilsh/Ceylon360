/// Custom exception class for handling various authentication and Firebase-related errors
class APPFirebaseAuthException implements Exception {
  /// The error code
  final String code;

  /// Constructor
  APPFirebaseAuthException(this.code);

  /// Get the corresponding error message based on the error code
  String get message {
    switch (code) {
      case 'email-already-in-use':
        return 'An account already exists with this email address.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'operation-not-allowed':
        return 'Operation is not allowed. Please contact support.';
      case 'weak-password':
        return 'Please enter a stronger password.';
      case 'user-disabled':
        return 'This user account has been disabled. Please contact support.';
      case 'user-not-found':
        return 'No user found with this email address.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'too-many-requests':
        return 'Too many requests. Please try again later.';
      case 'network-request-failed':
        return 'Network error. Please check your internet connection.';
      default:
        return 'An unexpected Firebase authentication error occurred.';
    }
  }
}

/// Custom exception class for general Firebase exceptions
class APPFirebaseException implements Exception {
  /// The error code
  final String code;

  /// Constructor
  APPFirebaseException(this.code);

  /// Get the corresponding error message based on the error code
  String get message {
    switch (code) {
      case 'permission-denied':
        return 'Permission denied. You do not have access to this resource.';
      case 'unavailable':
        return 'Firebase service is currently unavailable.';
      case 'deadline-exceeded':
        return 'Operation timeout. Please try again.';
      default:
        return 'An unexpected Firebase error occurred.';
    }
  }
}

/// Custom exception class for format-related errors
class APPFormatException implements Exception {
  /// Optional error message
  final String? message;

  /// Constructor
  const APPFormatException([this.message]);

  /// Default error message
  String get errorMessage {
    return message ?? 'An error in the data format occurred.';
  }
}

/// Custom exception class for platform-specific errors
class APPPlatformException implements Exception {
  /// The error code
  final String code;

  /// Constructor
  APPPlatformException(this.code);

  /// Get the corresponding error message based on the error code
  String get message {
    switch (code) {
      case 'sign_in_failed':
        return 'Sign-in process failed. Please try again.';
      case 'network_error':
        return 'Network error. Please check your connection.';
      case 'timeout':
        return 'Operation timed out. Please try again.';
      case 'no_such_method':
        return 'Method not supported on this platform.';
      default:
        return 'An unexpected platform error occurred.';
    }
  }
}

/// Utility class for handling and logging exceptions
class APPExceptionHandler {
  /// Private constructor to prevent instantiation
  APPExceptionHandler._();

  /// Handle and log exceptions
  static void handleException(Exception e) {
    if (e is APPFirebaseAuthException) {
      // Log or handle Firebase authentication specific errors
      print('Firebase Auth Error: ${e.message}');
    } else if (e is APPFirebaseException) {
      // Log or handle Firebase specific errors
      print('Firebase Error: ${e.message}');
    } else if (e is APPFormatException) {
      // Log or handle format-related errors
      print('Format Error: ${e.errorMessage}');
    } else if (e is APPPlatformException) {
      // Log or handle platform-specific errors
      print('Platform Error: ${e.message}');
    } else {
      // Handle any other unexpected errors
      print('Unexpected Error: ${e.toString()}');
    }
  }

  /// Show a user-friendly error dialog (you'd implement this with your UI framework)
  static void showErrorDialog(String message) {
    // Implement your error dialog logic here
    // This could use Get.snackbar(), showDialog(), or your app's error display method
    print('Error Dialog: $message');
  }
}
