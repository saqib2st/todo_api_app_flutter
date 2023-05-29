import 'package:get/get.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    // Delay navigation by 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      // Navigate to the next screen
      Get.toNamed('/todoList');
    });
  }
}
