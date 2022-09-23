import 'package:get/get.dart';
import 'package:greengrocer/src/modules/splash/splash_controller.dart';

class SplashBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(SplashController(authService: Get.find()));
  }
}
