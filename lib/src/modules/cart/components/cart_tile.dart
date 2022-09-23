import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greengrocer/src/core/config/custom_colors.dart';
import 'package:greengrocer/src/core/services/utils_service.dart';
import 'package:greengrocer/src/core/ui/common_widgets/quantity_widget.dart';
import 'package:greengrocer/src/models/cart_item_model.dart';
import 'package:greengrocer/src/modules/cart/cart_controller.dart';

class CartTile extends StatelessWidget {
  final CartItemModel cartItem;

  CartTile({
    Key? key,
    required this.cartItem,
  }) : super(key: key);

  final utilsService = Get.find<UtilsService>();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        // Imagem
        leading: Image.network(
          cartItem.item.imgUrl,
          height: 60,
          width: 60,
        ),

        // Titulo
        title: Text(
          cartItem.item.itemName,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),

        // Total
        subtitle: GetBuilder<CartController>(
          builder: (_) {
            return Text(
              utilsService.priceToCurrency(cartItem.totalPrice()),
              style: TextStyle(
                color: CustomColors.customSwatchColor,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),

        // Quantidade
        trailing: GetBuilder<CartController>(
          builder: (controller) {
            return QuantityWidget(
              value: cartItem.quantity,
              suffixText: cartItem.item.unit,
              result: (quantity) {
                controller.changeItemQuantity(
                  cartItem: cartItem,
                  quantity: quantity,
                );
              },
              isRemovable: true,
            );
          },
        ),
      ),
    );
  }
}
