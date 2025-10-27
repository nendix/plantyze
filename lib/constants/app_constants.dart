/// Application-wide constants for Plantyze
class AppConstants {
  // API Configuration
  static const int defaultNbResults = 5;
  static const String defaultLang = 'en';
  static const String defaultProject = 'all';
  static const List<String> supportedProjects = [
    'all',
    'weurope',
    'k-world-flora',
  ];

  // Image Processing
  static const int maxImageDimension = 1024;
  static const int imageQuality = 85;
  static const int maxFileSizeBytes = 5 * 1024 * 1024; // 5MB
  static const List<String> supportedImageFormats = ['.jpg', '.jpeg', '.png'];

  // UI Constants
  static const double confidenceThresholdHigh = 0.75;
  static const double confidenceThresholdMedium = 0.5;
  static const double plantCardImageSize = 120.0;
  static const double captureButtonSize = 80.0;

  // Network Configuration
  static const int requestTimeoutSeconds = 30;
  static const int maxRetryAttempts = 3;

  // Error Messages
  static const String errorNoInternet =
      'No internet connection. Please check your network and try again.';
  static const String errorInvalidApiKey =
      'Invalid API key. Please check your configuration.';
  static const String errorRequestTimeout =
      'Request timed out. Please try again.';
  static const String errorServerError =
      'Server error. Please try again later.';
  static const String errorTooManyRequests =
      'Too many requests. Please wait a moment and try again.';
  static const String errorImageTooLarge =
      'Image is too large. Please use a smaller image.';
  static const String errorUnsupportedFormat =
      'Unsupported image format. Please use JPG or PNG.';
  static const String errorNoPlantFound =
      'No plants could be identified in this image.';
}

