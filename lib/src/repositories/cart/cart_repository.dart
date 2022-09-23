import 'package:greengrocer/src/models/cart_item_model.dart';
import 'package:greengrocer/src/models/order_model.dart';
import 'package:greengrocer/src/modules/cart/result/cart_result.dart';

abstract class CartRepository {
  Future<CartResult<List<CartItemModel>>> getCartItems({
    required String token,
    required String userId,
  });

  Future<CartResult<String>> addItemToCart({
    required String token,
    required String userId,
    required String productId,
    required int quantity,
  });

  Future<bool> changeItemQuantity({
    required String token,
    required String cartItemId,
    required int quantity,
  });

  Future<CartResult<OrderModel>> checkoutCart({
    required String token,
    required double total,
  });
}
