import 'package:get/get.dart';

class ThemeController extends GetxController {
  var isDarkTheme = false;

  void toggleTheme() {
    isDarkTheme = !isDarkTheme;
    update();
  }
}