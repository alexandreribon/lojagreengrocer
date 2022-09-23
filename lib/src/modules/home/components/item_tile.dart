import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greengrocer/src/core/config/custom_colors.dart';
import 'package:greengrocer/src/models/item_model.dart';
import 'package:greengrocer/src/modules/cart/cart_controller.dart';
import 'package:greengrocer/src/modules/home/home_controller.dart';
import 'package:greengrocer/src/pages_routes/app_pages.dart';

class ItemTile extends StatelessWidget {
  final ItemModel item;
  final void Function(GlobalKey) cartAnimationMethod;

  ItemTile({
    Key? key,
    required this.item,
    required this.cartAnimationMethod,
  }) : super(key: key);

  final GlobalKey imageGk = GlobalKey();
  final cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            Get.toNamed(PagesRoutes.productRoute, arguments: item);
          },
          child: Card(
            elevation: 2,
            shadowColor: Colors.grey.shade300,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Hero(
                      tag: item.imgUrl,
                      child: Image.network(
                        item.imgUrl,
                        key: imageGk,
                      ),
                    ),
                  ),
                  Text(
                    item.itemName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        cartController.utilService.priceToCurrency(item.price),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: CustomColors.customSwatchColor,
                        ),
                      ),
                      Text(
                        '/${item.unit}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade600,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),

        // Botão adiciona no carrinho
        Positioned(
          top: 4,
          right: 4,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(15),
              topRight: Radius.circular(20),
            ),
            child: Material(
              child: GetBuilder<HomeController>(
                builder: (homeController) {
                  return InkWell(
                    onTap: () {
                      homeController.switchIcon();
                      cartAnimationMethod(imageGk);
                      cartController.addItemToCart(item: item);
                    },
                    child: Ink(
                      height: 40,
                      width: 35,
                      decoration: BoxDecoration(
                        color: CustomColors.customSwatchColor,
                      ),
                      child: Icon(
                        homeController.tileIcon,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        )
      ],
    );
  }
}
