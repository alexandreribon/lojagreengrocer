import 'package:get/get.dart';

import 'package:greengrocer/src/core/services/auth_service.dart';
import 'package:greengrocer/src/core/services/utils_service.dart';
import 'package:greengrocer/src/models/order_model.dart';
import 'package:greengrocer/src/repositories/orders/orders_repository.dart';

class OrderItemsController extends GetxController {
  OrderModel order;

  OrderItemsController({
    required this.order,
  });

  final _ordersRepository = Get.find<OrdersRepository>();
  final _authService = Get.find<AuthService>();
  final _utilsService = Get.find<UtilsService>();

  bool isLoading = false;

  void setLoading(bool value) {
    isLoading = value;
    update();
  }

  Future<void> getOrderItems() async {
    setLoading(true);

    var result = await _ordersRepository.getOrderItems(
      token: _authService.user!.token!,
      orderId: order.id,
    );

    setLoading(false);

    result.when(
      success: (items) {
        order.items = items;
        update();
      },
      error: (message) {
        _utilsService.showToast(message: message, isError: true);
      },
    );
  }
}
