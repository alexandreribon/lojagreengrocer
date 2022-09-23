import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greengrocer/src/core/services/utils_service.dart';
import 'package:greengrocer/src/models/order_model.dart';

class PaymentDialog extends StatelessWidget {
  final OrderModel order;

  PaymentDialog({
    Key? key,
    required this.order,
  }) : super(key: key);

  final utilsService = Get.find<UtilsService>();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Conteudo
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Título
                const Padding(
                  padding: EdgeInsets.only(top: 15, bottom: 5),
                  child: Text(
                    'Pagamento com Pix',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // QR Code
                Image.memory(
                  utilsService.decodeQrCodeImage(order.qrCodeImage),
                  height: 200,
                  width: 200,
                ),

                /* QrImage(
                  data: '1234567890',
                  version: QrVersions.auto,
                  size: 200,
                ), */

                // Vencimento
                Text(
                  'Vencimento: ${utilsService.formatDateTime(order.overdueDateTime)}',
                  style: const TextStyle(fontSize: 13),
                ),

                const SizedBox(height: 6),
                // Total
                Text(
                  'Total: ${utilsService.priceToCurrency(order.total)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                // Botão copia e cola
                OutlinedButton.icon(
                  onPressed: () {
                    FlutterClipboard.copy(order.copyAndPaste);
                    utilsService.showToast(message: 'Código copiado');
                  },
                  icon: const Icon(
                    Icons.copy,
                    size: 15,
                  ),
                  label: const Text(
                    'Copiar código Pix',
                    style: TextStyle(fontSize: 13),
                  ),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    side: const BorderSide(
                      width: 2,
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Botão fechar
          Positioned(
            top: 0,
            right: 1,
            child: IconButton(
              onPressed: () => Get.back(), //Navigator.of(context).pop(),
              icon: const Icon(Icons.close),
            ),
          ),
        ],
      ),
    );
  }
}
