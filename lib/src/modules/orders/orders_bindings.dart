import 'package:get/get.dart';
import 'package:greengrocer/src/modules/orders/orders_controller.dart';
import 'package:greengrocer/src/repositories/orders/orders_repository.dart';
import 'package:greengrocer/src/repositories/orders/orders_repository_impl.dart';

class OrdersBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrdersRepository>(
      () => OrdersRepositoryImpl(httpManager: Get.find()),
    );
    Get.put(
      OrdersController(
        ordersRepository: Get.find(),
        authService: Get.find(),
        utilsService: Get.find(),
      ),
    );
  }
}
