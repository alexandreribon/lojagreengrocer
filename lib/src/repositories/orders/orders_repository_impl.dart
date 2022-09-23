import 'package:greengrocer/src/core/constants/endpoints.dart';
import 'package:greengrocer/src/core/http_manager/http_manager.dart';
import 'package:greengrocer/src/models/cart_item_model.dart';
import 'package:greengrocer/src/modules/orders/result/orders_result.dart';

import 'package:greengrocer/src/models/order_model.dart';

import './orders_repository.dart';

class OrdersRepositoryImpl implements OrdersRepository {
  final HttpManager _httpManager;

  OrdersRepositoryImpl({
    required HttpManager httpManager,
  }) : _httpManager = httpManager;

  @override
  Future<OrdersResult<List<OrderModel>>> getAllOrders({
    required String token,
    required String userId,
  }) async {
    final result = await _httpManager.restRequest(
      url: Endpoints.getAllOrders,
      method: HttpMethods.post,
      headers: {
        'X-Parse-Session-Token': token,
      },
      body: {
        'user': userId,
      },
    );

    if (result['result'] != null) {
      var data = List<Map<String, dynamic>>.from(result['result']);
      var orders = data.map<OrderModel>(OrderModel.fromMap).toList();
      return OrdersResult<List<OrderModel>>.success(orders);
    } else {
      return OrdersResult.error('Ocorreu um erro ao buscar os pedidos');
    }
  }

  @override
  Future<OrdersResult<List<CartItemModel>>> getOrderItems({
    required String token,
    required String orderId,
  }) async {
    final result = await _httpManager.restRequest(
      url: Endpoints.getOrderItems,
      method: HttpMethods.post,
      headers: {
        'X-Parse-Session-Token': token,
      },
      body: {
        'orderId': orderId,
      },
    );

    if (result['result'] != null) {
      var data = List<Map<String, dynamic>>.from(result['result']);
      var orderItems = data.map<CartItemModel>(CartItemModel.fromMap).toList();
      return OrdersResult<List<CartItemModel>>.success(orderItems);
    } else {
      return OrdersResult.error('Ocorreu um erro ao buscar os itens do pedido');
    }
  }
}
