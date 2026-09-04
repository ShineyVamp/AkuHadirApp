import 'package:flutter/material.dart';
import 'package:akuhadir/core/services/storage_service.dart';
class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeProvider() {
    _loadTheme();
  }

  void _loadTheme() {
    _isDarkMode = StorageService.getIsDarkMode();
    notifyListeners();
  }

  Future<void> toggleTheme(bool value) async {
    _isDarkMode = value;
    await StorageService.setIsDarkMode(value);
    notifyListeners();
  }
}
