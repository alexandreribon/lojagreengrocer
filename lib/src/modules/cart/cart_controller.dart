import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greengrocer/src/core/mixins/loader_mixin.dart';
import 'package:greengrocer/src/core/services/auth_service.dart';
import 'package:greengrocer/src/core/services/utils_service.dart';
import 'package:greengrocer/src/core/ui/common_widgets/payment_dialog.dart';
import 'package:greengrocer/src/models/cart_item_model.dart';
import 'package:greengrocer/src/models/item_model.dart';
import 'package:greengrocer/src/repositories/cart/cart_repository.dart';

class CartController extends GetxController with LoaderMixin {
  final CartRepository _cartRepository;
  final AuthService _authService;
  final UtilsService _utilsService;

  CartController(
      {required CartRepository cartRepository,
      required AuthService authService,
      required UtilsService utilsService})
      : _cartRepository = cartRepository,
        _authService = authService,
        _utilsService = utilsService;

  final _isLoading = false.obs;
  final _isCheckoutLoading = false.obs;
  final _cartItems = <CartItemModel>[].obs;
  final _cartTotalPrice = 0.0.obs;
  final _cartTotalItems = 0.obs;
  final _cartItemQuantity = 0.obs;

  @override
  void onInit() {
    loaderListener(_isLoading);
    loaderListener(_isCheckoutLoading);
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    getCartItems();
  }

  UtilsService get utilService => _utilsService;
  List<CartItemModel> get cartItems => _cartItems;
  double get cartTotalPrice => _cartTotalPrice.value;
  int get cartTotalItems => _cartTotalItems.value;
  int get cartItemQuantity => _cartItemQuantity.value;
  set cartItemQuantity(int value) => _cartItemQuantity.value = value;

  Future<void> getCartItems() async {
    _isLoading(true);

    var result = await _cartRepository.getCartItems(
      token: _authService.user!.token!,
      userId: _authService.user!.id!,
    );

    //await 600.milliseconds.delay();

    _isLoading(false);

    result.when(
      success: (data) {
        _cartItems.assignAll(data);
        _calculeCartTotalPrice();
        _calculeCarttotalItems();
      },
      error: (message) {
        _utilsService.showToast(message: message, isError: true);
      },
    );
  }

  Future<void> addItemToCart({
    required ItemModel item,
    int quantity = 1,
  }) async {
    var cartItemIndex = _getCartItemIndex(item);
    if (cartItemIndex >= 0) {
      // item existe no carrinho

      final cartItem = _cartItems[cartItemIndex];
      cartItem.quantity += quantity;

      final result = await changeItemQuantity(
        cartItem: cartItem,
        quantity: cartItem.quantity,
      );

      if (result == false) {
        _utilsService.showToast(
          message: 'Ocorreu um erro ao alterar a quantidade do produto no carrinho',
          isError: true,
        );
      }
    } else {
      // add novo item no carrinho

      var result = await _cartRepository.addItemToCart(
        token: _authService.user!.token!,
        userId: _authService.user!.id!,
        productId: item.id,
        quantity: quantity,
      );

      result.when(
        success: (cartItemId) {
          _cartItems.add(CartItemModel(
            id: cartItemId,
            item: item,
            quantity: quantity,
          ));
          _calculeCartTotalPrice();
          _calculeCarttotalItems();
        },
        error: (message) {
          _utilsService.showToast(message: message, isError: true);
        },
      );
    }
  }

  Future<bool> changeItemQuantity({
    required CartItemModel cartItem,
    required int quantity,
  }) async {
    var result = await _cartRepository.changeItemQuantity(
      token: _authService.user!.token!,
      cartItemId: cartItem.id,
      quantity: quantity,
    );

    if (result) {
      if (quantity == 0) {
        _cartItems.remove(cartItem);
      } else {
        var cartIt = _cartItems.firstWhere((element) => element.id == cartItem.id);
        cartIt.quantity = quantity;
      }
      _calculeCartTotalPrice();
      _calculeCarttotalItems();
      update();
    }

    return result;
  }

  Future<void> checkoutCart() async {
    _isCheckoutLoading(true);

    var result = await _cartRepository.checkoutCart(
      token: _authService.user!.token!,
      total: _cartTotalPrice.value,
    );

    _isCheckoutLoading(false);

    result.when(
      success: (order) {
        showDialog(
          barrierDismissible: false,
          context: Get.context!,
          builder: (_) => PaymentDialog(order: order),
        );
        _cleanCart();
      },
      error: (message) {
        _utilsService.showToast(message: message, isError: true);
      },
    );
  }

  void _cleanCart() {
    _cartItems.clear();
    _cartTotalItems.value = 0;
    _cartTotalPrice.value = 0.0;
  }

  void _calculeCartTotalPrice() {
    double total = 0;

    for (var cartItem in _cartItems) {
      total += cartItem.totalPrice();
    }

    _cartTotalPrice.value = total;
  }

  void _calculeCarttotalItems() {
    _cartTotalItems.value = _cartItems.isEmpty
        ? 0
        : _cartItems
            .map(
              (e) => e.quantity,
            )
            .reduce((a, b) => a + b);
  }

  int _getCartItemIndex(ItemModel item) {
    return _cartItems.indexWhere((cartItem) => cartItem.item.id == item.id);
  }
}
