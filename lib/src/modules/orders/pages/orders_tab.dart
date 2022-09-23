import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greengrocer/src/modules/orders/components/order_tile.dart';
import 'package:greengrocer/src/modules/orders/orders_controller.dart';

class OrdersTab extends GetView<OrdersController> {
  const OrdersTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pedidos',
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        return RefreshIndicator(
          onRefresh: () => controller.getAllOrders(),
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            physics: const AlwaysScrollableScrollPhysics(),
            separatorBuilder: (_, index) => const SizedBox(height: 10),
            itemCount: controller.orders.length,
            itemBuilder: (_, index) => OrderTile(order: controller.orders[index]),
          ),
        );
      }),
    );
  }
}
