import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_management/controller/task_controller.dart';
import 'package:task_management/controller/theme_controller.dart';
import 'package:task_management/view/home_page.dart';

void main() {
  Get.put(TaskController());
  Get.put(ThemeController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final TaskController taskController = Get.put(TaskController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      assignId: true,
      builder: (controller) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'ToDo App',
          theme: controller.isDarkTheme ? ThemeData.dark() : ThemeData.light(),


          // theme: controller.isDarkTheme ? ThemeData.dark() : ThemeData.light(),
          home: HomePage(),
        );
      },
    );
  }
}