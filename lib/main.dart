import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_api_test/controller.dart';
import 'package:todo_api_test/screens/splash.dart';
import 'package:todo_api_test/screens/todo_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      initialRoute: '/',
      getPages: [
        GetPage(
          name: '/',
          page: () => const SplashScreen(),
          binding: BindingsBuilder(() {
            // Bind the SplashController to the SplashScreen
            Get.put(SplashController());
          }),
        ),
        GetPage(
          name: '/todoList',
          page: () => const TodoListPage(),
        ),
      ],
    );
  }
}
