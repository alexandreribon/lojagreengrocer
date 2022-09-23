import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greengrocer/src/core/ui/common_widgets/payment_dialog.dart';
import 'package:greengrocer/src/models/order_model.dart';
import 'package:greengrocer/src/modules/orders/components/order_status.dart';
import 'package:greengrocer/src/core/services/utils_service.dart';
import 'package:greengrocer/src/modules/orders/order_items_controller.dart';

class OrderTile extends StatelessWidget {
  final OrderModel order;

  OrderTile({
    Key? key,
    required this.order,
  }) : super(key: key);

  final UtilsService utilsService = Get.find<UtilsService>();

  @override
  Widget build(BuildContext context) {
    bool isOverdue = order.overdueDateTime.isBefore(DateTime.now());

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: GetBuilder<OrderItemsController>(
          init: OrderItemsController(order: order),
          global: false,
          builder: (controller) {
            return ExpansionTile(
              onExpansionChanged: (open) {
                if (open && order.items.isEmpty) {
                  controller.getOrderItems();
                }
              },
              // initiallyExpanded: order.status == 'pending_payment',
              title: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pedido: ${order.id}',
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    utilsService.formatDateTime(order.createdDateTime!),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
              children: controller.isLoading
                  ? [
                      Container(
                        padding: const EdgeInsets.only(right: 150),
                        height: 80,
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator(),
                      ),
                    ]
                  : [
                      IntrinsicHeight(
                        child: Row(
                          children: [
                            // Itens do pedido
                            Expanded(
                              flex: 3,
                              child: SizedBox(
                                height: 190,
                                child: ListView(
                                  padding: EdgeInsets.zero,
                                  children: controller.order.items.map((orderItem) {
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 6),
                                      child: Row(
                                        children: [
                                          Text(
                                            '${orderItem.quantity} ${orderItem.item.unit} ',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              orderItem.item.itemName,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            utilsService.priceToCurrency(orderItem.totalPrice()),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            VerticalDivider(
                              color: Colors.grey.shade300,
                              thickness: 2,
                              width: 10,
                            ),
                            // Status do pedido
                            Expanded(
                              flex: 2,
                              child: OrderStatus(
                                status: order.status,
                                isOverdue: isOverdue,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Total Geral
                      Text.rich(
                        TextSpan(
                          style: const TextStyle(fontSize: 18),
                          children: [
                            const TextSpan(
                              text: 'Total: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: utilsService.priceToCurrency(order.total),
                            ),
                          ],
                        ),
                      ),

                      // Botão pagamento
                      Visibility(
                        visible: order.status == 'pending_payment' && !isOverdue,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (_) => PaymentDialog(order: order),
                            );
                          },
                          icon: Image.asset(
                            'assets/images/pix.png',
                            height: 18,
                          ),
                          label: const Text(
                            'Ver QR Code Pix',
                            style: TextStyle(fontSize: 16),
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                    ],
            );
          },
        ),
      ),
    );
  }
}
