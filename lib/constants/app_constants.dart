/// Application-wide constants for Plantyze
class AppConstants {
  // API Configuration
  static const int defaultNbResults = 5;
  static const String defaultLang = 'en';
  static const String defaultProject = 'all';

  // Image Processing
  static const int maxFileSizeBytes = 15 * 1024 * 1024; // 15MB
  static const List<String> supportedImageFormats = ['.jpg', '.jpeg', '.png'];

  // Network Configuration
  static const int requestTimeoutSeconds = 30;
}

