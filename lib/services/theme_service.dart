import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppThemeMode {
  system,
  light,
  dark,
}

class ThemeService extends ChangeNotifier {
  static const String _themeKey = 'app_theme_mode';
  
  AppThemeMode _themeMode = AppThemeMode.system;
  SharedPreferences? _prefs;

  AppThemeMode get themeMode => _themeMode;

  ThemeMode get materialThemeMode {
    switch (_themeMode) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    if (_prefs == null) return;
    
    final savedThemeIndex = _prefs!.getInt(_themeKey);
    if (savedThemeIndex != null && 
        savedThemeIndex >= 0 && 
        savedThemeIndex < AppThemeMode.values.length) {
      _themeMode = AppThemeMode.values[savedThemeIndex];
      notifyListeners();
    }
  }

  Future<void> setThemeMode(AppThemeMode mode) async {
    if (_themeMode == mode) return;
    
    _themeMode = mode;
    await _saveThemeMode();
    notifyListeners();
  }

  Future<void> _saveThemeMode() async {
    if (_prefs == null) return;
    await _prefs!.setInt(_themeKey, _themeMode.index);
  }

  String getThemeModeDisplayName(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.system:
        return 'System';
      case AppThemeMode.light:
        return 'Light';
      case AppThemeMode.dark:
        return 'Dark';
    }
  }

  IconData getThemeModeIcon(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.system:
        return Icons.brightness_auto;
      case AppThemeMode.light:
        return Icons.brightness_7;
      case AppThemeMode.dark:
        return Icons.brightness_2;
    }
  }
}