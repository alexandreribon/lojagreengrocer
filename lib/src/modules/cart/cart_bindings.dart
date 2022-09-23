import 'package:get/get.dart';
import 'package:greengrocer/src/modules/cart/cart_controller.dart';
import 'package:greengrocer/src/repositories/cart/cart_repository.dart';
import 'package:greengrocer/src/repositories/cart/cart_repository_impl.dart';

class CartBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CartRepository>(() => CartRepositoryImpl(
          httpManager: Get.find(),
        ));
    Get.put(CartController(
      cartRepository: Get.find(),
      authService: Get.find(),
      utilsService: Get.find(),
    ));
  }
}
