/// Custom exception class for handling various authentication and Firebase-related errors
class APPFirebaseAuthException implements Exception {
  /// The error code
  final String code;

  /// Constructor
  APPFirebaseAuthException(this.code);

  /// Get the corresponding error message based on the error code
  String get message {
    switch (code) {
      // Account Existence/Creation Errors
      case 'email-already-in-use':
        return 'An account already exists with this email address.';
      case 'account-exists-with-different-credential':
        return 'An account already exists with the same email but different sign-in credentials.';
      case 'credential-already-in-use':
        return 'This credential is already associated with a different user account.';

      // Email Validation Errors
      case 'invalid-email':
        return 'The email address is not valid.';

      // Password Related Errors
      case 'weak-password':
        return 'Please enter a stronger password.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'invalid-password':
        return 'The password is invalid. It must be at least 6 characters.';
      case 'invalid-credential':
        return 'The credentials are malformed or have expired.';

      // User Account Status Errors
      case 'user-disabled':
        return 'This user account has been disabled. Please contact support.';
      case 'user-not-found':
        return 'No user found with this email address.';
      case 'user-token-expired':
        return 'Your session has expired. Please sign in again.';
      case 'invalid-user-token':
        return 'Your session is invalid. Please sign in again.';
      case 'user-token-revoked':
        return 'Your session has been revoked. Please sign in again.';

      // MFA/2FA Related Errors
      case 'second-factor-required':
        return 'This account requires a second authentication factor.';
      case 'multi-factor-auth-required':
        return 'Multi-factor authentication is required to access this account.';

      // Rate Limiting & Operational Errors
      case 'too-many-requests':
        return 'Too many requests. Please try again later.';
      case 'operation-not-allowed':
        return 'Operation is not allowed. Please contact support.';
      case 'requires-recent-login':
        return 'This operation is sensitive and requires recent authentication. Please log in again.';

      // Network Related Errors
      case 'network-request-failed':
        return 'Network error. Please check your internet connection.';

      // Verification Errors
      case 'invalid-verification-code':
        return 'The verification code is invalid.';
      case 'invalid-verification-id':
        return 'The verification ID is invalid.';
      case 'captcha-check-failed':
        return 'The CAPTCHA check failed. Please try again.';
      case 'app-not-authorized':
        return 'This app is not authorized to use Firebase Authentication.';

      // Provider-Specific Errors
      case 'provider-already-linked':
        return 'This provider is already linked to your account.';
      case 'no-such-provider':
        return 'This provider is not linked to your account.';
      case 'invalid-provider-id':
        return 'The specified provider ID is invalid.';

      // API Errors
      case 'invalid-api-key':
        return 'The API key is invalid.';
      case 'app-not-installed':
        return 'The requested application is not installed on this device.';
      case 'web-storage-unsupported':
        return 'Your browser does not support web storage or it is disabled.';

      // Missing or Default Case
      default:
        // Log the unhandled code for debugging
        print('Unhandled Firebase Auth error code: $code');
        return 'An unexpected Firebase authentication error occurred. Error code: $code';
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
      // Permission Errors
      case 'permission-denied':
        return 'Permission denied. You do not have access to this resource.';

      // Server Status Errors
      case 'unavailable':
        return 'Firebase service is currently unavailable.';
      case 'internal':
        return 'An internal error has occurred in the Firebase service.';
      case 'unauthenticated':
        return 'User authentication required. Please sign in.';

      // Rate Limiting & Operation Errors
      case 'resource-exhausted':
        return 'Quota exceeded or rate limit reached. Please try again later.';
      case 'deadline-exceeded':
        return 'Operation timeout. Please try again.';
      case 'cancelled':
        return 'The operation was cancelled.';

      // Data Errors
      case 'invalid-argument':
        return 'Invalid argument provided to the Firebase operation.';
      case 'not-found':
        return 'The requested resource was not found.';
      case 'already-exists':
        return 'The resource already exists.';
      case 'data-loss':
        return 'Data loss or corruption occurred.';
      case 'failed-precondition':
        return 'Operation was rejected because the system is not in a state required for the operation.';
      case 'aborted':
        return 'The operation was aborted.';
      case 'out-of-range':
        return 'Operation was attempted past the valid range.';
      case 'unimplemented':
        return 'Operation is not implemented or not supported.';

      // Default Case
      default:
        // Log the unhandled code for debugging
        print('Unhandled Firebase error code: $code');
        return 'An unexpected Firebase error occurred. Error code: $code';
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
      // Authentication Errors
      case 'sign_in_failed':
        return 'Sign-in process failed. Please try again.';
      case 'sign_in_cancelled':
        return 'Sign-in was cancelled.';
      case 'popup_blocked':
        return 'Pop-up window was blocked by the browser. Please allow pop-ups for this site.';

      // Network Errors
      case 'network_error':
        return 'Network error. Please check your connection.';
      case 'timeout':
        return 'Operation timed out. Please try again.';
      case 'ssl_error':
        return 'SSL certificate error. Connection is not secure.';

      // Permission Errors
      case 'permission_denied':
        return 'Permission denied for this operation.';

      // Feature Support Errors
      case 'no_such_method':
        return 'Method not supported on this platform.';
      case 'not_implemented':
        return 'This feature is not implemented on your device.';

      // Hardware Errors
      case 'camera_access_denied':
        return 'Camera access denied. Please check your permission settings.';
      case 'microphone_access_denied':
        return 'Microphone access denied. Please check your permission settings.';
      case 'location_access_denied':
        return 'Location access denied. Please check your permission settings.';

      // Storage Errors
      case 'storage_full':
        return 'Device storage is full. Please free up some space.';
      case 'file_not_found':
        return 'The requested file was not found.';

      // Default Case
      default:
        // Log the unhandled code for debugging
        print('Unhandled Platform error code: $code');
        return 'An unexpected platform error occurred. Error code: $code';
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
