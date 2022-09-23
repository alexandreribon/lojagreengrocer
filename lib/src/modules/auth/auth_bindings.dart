import 'package:get/get.dart';
import 'package:greengrocer/src/modules/auth/auth_controller.dart';

class AuthBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthController(
          authRepository: Get.find(),
          storageService: Get.find(),
          utilsService: Get.find(),
          authService: Get.find(),
        ));
  }
}
