import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greengrocer/src/core/config/custom_colors.dart';
import 'package:greengrocer/src/core/constants/navigation_tabs.dart';
import 'package:greengrocer/src/core/ui/common_widgets/quantity_widget.dart';
import 'package:greengrocer/src/models/item_model.dart';
import 'package:greengrocer/src/modules/base/base_controller.dart';
import 'package:greengrocer/src/modules/cart/cart_controller.dart';

class ProductScreen extends GetView<CartController> {
  ProductScreen({Key? key}) : super(key: key);

  final baseController = Get.find<BaseController>();
  final ItemModel item = Get.arguments;

  @override
  Widget build(BuildContext context) {
    controller.cartItemQuantity = 1;

    return Scaffold(
      backgroundColor: Colors.white.withAlpha(230),
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(
                height: 38,
              ),
              Expanded(
                child: Hero(
                  tag: item.imgUrl,
                  child: Image.network(item.imgUrl),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(50),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade600,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              item.itemName,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Obx(() {
                            return QuantityWidget(
                              value: controller.cartItemQuantity,
                              suffixText: item.unit,
                              result: (quantity) {
                                controller.cartItemQuantity = quantity;
                              },
                            );
                          }),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          controller.utilService.priceToCurrency(item.price),
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: CustomColors.customSwatchColor,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: SingleChildScrollView(
                            child: Text(
                              item.description,
                              style: const TextStyle(height: 1.3),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 55,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          onPressed: () {
                            Get.back();
                            controller.addItemToCart(
                              item: item,
                              quantity: controller.cartItemQuantity,
                            );
                            baseController.goToPage(NavigationTabs.cart); //vai p/ carrnho
                          },
                          icon: const Icon(
                            Icons.shopping_cart_outlined,
                            color: Colors.white,
                          ),
                          label: const Text(
                            'Adicionar ao carrinho',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            left: 10,
            top: 6,
            child: SafeArea(
              child: IconButton(
                onPressed: () => Get.back(), //Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back_ios),
              ),
            ),
          )
        ],
      ),
    );
  }
}
