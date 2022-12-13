import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';

class ThemeServices extends GetxController {
  final GetStorage box = GetStorage();
  final key = 'isDarkMode';

  saveThemeToBOx(bool isDarkMode) => box.write(key, isDarkMode);

  bool loadThemeFromBox() => box.read<bool>(key) ?? false;

  ThemeMode get theme => loadThemeFromBox() ? ThemeMode.dark : ThemeMode.light;
  void switchTheme() {
    Get.changeThemeMode(loadThemeFromBox() ? ThemeMode.light : ThemeMode.dark);
    saveThemeToBOx(!loadThemeFromBox());
    update();
  }
}
