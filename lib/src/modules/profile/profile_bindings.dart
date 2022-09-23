import 'package:get/get.dart';
import 'package:greengrocer/src/modules/profile/profile_controller.dart';

class ProfileBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProfileController(
          authService: Get.find(),
          authRepository: Get.find(),
          utilsService: Get.find(),
        ));
  }
}
