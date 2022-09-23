import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greengrocer/src/core/config/custom_colors.dart';
import 'package:greengrocer/src/modules/cart/cart_controller.dart';
import 'package:greengrocer/src/modules/cart/components/cart_tile.dart';

class CartTab extends GetView<CartController> {
  const CartTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Carrinho',
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          //Lista de itens do carrinho
          Expanded(
            child: Obx(() {
              if (controller.cartItems.isEmpty) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.remove_shopping_cart,
                      color: CustomColors.customSwatchColor,
                      size: 75,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Não há itens no carrinho',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                );
              }

              return ListView.builder(
                itemCount: controller.cartItems.length,
                itemBuilder: (_, index) {
                  return CartTile(
                    cartItem: controller.cartItems[index],
                  );
                },
              );
            }),
          ),

          //Total e botão de Finalizar compra
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 3,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Total Geral',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Obx(() {
                  return Text(
                    controller.utilService.priceToCurrency(controller.cartTotalPrice),
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      color: CustomColors.customSwatchColor,
                    ),
                  );
                }),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 50,
                  child: Obx(() {
                    return ElevatedButton(
                      onPressed: controller.cartItems.isEmpty
                          ? null
                          : () async {
                              bool? result = await _showOrderConfirmation(context);
                              if (result ?? false) {
                                controller.checkoutCart();
                              } else {
                                controller.utilService.showToast(message: 'Pedido não realizado');
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        primary: CustomColors.customSwatchColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: const Text(
                        'Finalizar Compra',
                        style: TextStyle(fontSize: 20),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<bool?> _showOrderConfirmation(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Confirmação'),
          content: const Text('Deseja realmente concluir o pedido'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Não'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text('Sim'),
            ),
          ],
        );
      },
    );
  }
}
