import 'package:flutter/material.dart';
import 'package:greengrocer/src/core/config/custom_colors.dart';

class OrderStatus extends StatelessWidget {
  final String status;
  final bool isOverdue;

  final Map<String, int> allStatus = <String, int>{
    'pending_payment': 0,
    'refunded': 1,
    'paid': 2,
    'preparing_purchase': 3,
    'shipping': 4,
    'delivered': 5,
  };

  int get currentStatus => allStatus[status]!;

  OrderStatus({
    Key? key,
    required this.status,
    required this.isOverdue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _StatusDot(title: 'Pedido Confirmado', isActive: true),
        const _CustomDivider(),
        if (currentStatus == 1) ...[
          const _StatusDot(
            isActive: true,
            title: 'Pix Estornado',
            backgroundColor: Colors.orange,
          ),
        ] else if (isOverdue && currentStatus <= 1) ...[
          const _StatusDot(
            isActive: true,
            title: 'Pagamento Pix Vencido',
            backgroundColor: Colors.red,
          ),
        ] else ...[
          _StatusDot(title: 'Pagamento', isActive: currentStatus >= 2),
          const _CustomDivider(),
          _StatusDot(title: 'Preparando', isActive: currentStatus >= 3),
          const _CustomDivider(),
          _StatusDot(title: 'Enviado', isActive: currentStatus >= 4),
          const _CustomDivider(),
          _StatusDot(title: 'Entregue', isActive: currentStatus == 5),
        ],
      ],
    );
  }
}

class _StatusDot extends StatelessWidget {
  final bool isActive;
  final String title;
  final Color? backgroundColor;

  const _StatusDot({
    Key? key,
    required this.isActive,
    required this.title,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          alignment: Alignment.center,
          height: 21,
          width: 21,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: CustomColors.customSwatchColor,
            ),
            color:
                isActive ? backgroundColor ?? CustomColors.customSwatchColor : Colors.transparent,
          ),
          child: isActive
              ? const Icon(
                  Icons.check,
                  size: 14,
                  color: Colors.white,
                )
              : const SizedBox.shrink(),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }
}

class _CustomDivider extends StatelessWidget {
  const _CustomDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      height: 11,
      width: 2,
      color: Colors.grey.shade300,
    );
  }
}
