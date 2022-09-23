import 'package:get/get.dart';
import 'package:greengrocer/src/modules/base/base_controller.dart';

class BaseBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(BaseController(), permanent: true);
  }
}
