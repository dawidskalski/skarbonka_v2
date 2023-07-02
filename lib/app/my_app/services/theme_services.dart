import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeServices {
  final _box = GetStorage();
  final _key = 'isDarkMode';

  dynamic _saveThemeFromBox(bool isDarkMode) {
    _box.write(_key, isDarkMode);
  }

  bool _loadThemeFromBox() {
    return _box.read(_key) ?? false;
  }

  ThemeMode getTheme() {
    return _loadThemeFromBox() ? ThemeMode.dark : ThemeMode.light;
  }

  void switchThemeMode() {
    Get.changeThemeMode(_loadThemeFromBox() ? ThemeMode.light : ThemeMode.dark);
    _saveThemeFromBox(!_loadThemeFromBox());
  }
}
