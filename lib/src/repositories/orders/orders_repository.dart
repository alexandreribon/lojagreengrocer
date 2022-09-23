import 'package:greengrocer/src/models/cart_item_model.dart';
import 'package:greengrocer/src/models/order_model.dart';
import 'package:greengrocer/src/modules/orders/result/orders_result.dart';

abstract class OrdersRepository {
  Future<OrdersResult<List<OrderModel>>> getAllOrders({
    required String token,
    required String userId,
  });

  Future<OrdersResult<List<CartItemModel>>> getOrderItems({
    required String token,
    required String orderId,
  });
}
