import 'package:greengrocer/src/core/constants/endpoints.dart';
import 'package:greengrocer/src/core/http_manager/http_manager.dart';
import 'package:greengrocer/src/models/order_model.dart';
import 'package:greengrocer/src/modules/cart/result/cart_result.dart';
import 'package:greengrocer/src/models/cart_item_model.dart';
import './cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  final HttpManager _httpManager;

  CartRepositoryImpl({
    required HttpManager httpManager,
  }) : _httpManager = httpManager;

  @override
  Future<CartResult<List<CartItemModel>>> getCartItems({
    required String token,
    required String userId,
  }) async {
    final result = await _httpManager.restRequest(
      url: Endpoints.getCartItems,
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
      var cartItems = data.map<CartItemModel>(CartItemModel.fromMap).toList();
      return CartResult<List<CartItemModel>>.success(cartItems);
    } else {
      return CartResult.error('Ocorreu um erro ao buscar os itens do carrinho');
    }
  }

  @override
  Future<CartResult<String>> addItemToCart({
    required String token,
    required String userId,
    required String productId,
    required int quantity,
  }) async {
    final result = await _httpManager.restRequest(
      url: Endpoints.addItemToCart,
      method: HttpMethods.post,
      headers: {
        'X-Parse-Session-Token': token,
      },
      body: {
        'user': userId,
        'productId': productId,
        'quantity': quantity,
      },
    );

    if (result['result'] != null) {
      return CartResult<String>.success(result['result']['id']);
    } else {
      return CartResult.error('Ocorreu um erro ao adicionar o item no carrinho');
    }
  }

  @override
  Future<bool> changeItemQuantity({
    required String token,
    required String cartItemId,
    required int quantity,
  }) async {
    final result = await _httpManager.restRequest(
      url: Endpoints.changeItemQuantity,
      method: HttpMethods.post,
      headers: {
        'X-Parse-Session-Token': token,
      },
      body: {
        'cartItemId': cartItemId,
        'quantity': quantity,
      },
    );

    return result.isEmpty;
  }

  @override
  Future<CartResult<OrderModel>> checkoutCart({
    required String token,
    required double total,
  }) async {
    final result = await _httpManager.restRequest(
      url: Endpoints.checkout,
      method: HttpMethods.post,
      headers: {
        'X-Parse-Session-Token': token,
      },
      body: {
        'total': total,
      },
    );

    if (result['result'] != null) {
      final order = OrderModel.fromMap(result['result']);
      return CartResult<OrderModel>.success(order);
    } else {
      return CartResult.error('Não foi possível realizar o pedido');
    }
  }
}
