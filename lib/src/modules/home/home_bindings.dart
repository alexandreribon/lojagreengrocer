import 'package:get/get.dart';
import 'package:greengrocer/src/modules/home/home_controller.dart';
import 'package:greengrocer/src/repositories/home/home_repository.dart';
import 'package:greengrocer/src/repositories/home/home_repository_impl.dart';

class HomeBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeRepository>(() => HomeRepositoryImpl(
          httpManager: Get.find(),
        ));
    Get.put(HomeController(
      homeRepository: Get.find(),
      utilsService: Get.find(),
    ));
  }
}
