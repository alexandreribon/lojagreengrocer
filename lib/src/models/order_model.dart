import 'dart:convert';

import 'package:greengrocer/src/models/cart_item_model.dart';

class OrderModel {
  String id;
  DateTime? createdDateTime;
  DateTime overdueDateTime;
  List<CartItemModel> items;
  String status;
  String qrCodeImage;
  String copyAndPaste;
  double total;

  OrderModel({
    required this.id,
    this.createdDateTime,
    required this.overdueDateTime,
    required this.items,
    required this.status,
    required this.qrCodeImage,
    required this.copyAndPaste,
    required this.total,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    if (createdDateTime != null) {
      result.addAll({'createdAt': createdDateTime!.toIso8601String()});
    }
    result.addAll(
        {'due': overdueDateTime.toIso8601String()}); //overdueDateTime.millisecondsSinceEpoch
    result.addAll({'items': items.map((x) => x.toMap()).toList()});
    result.addAll({'status': status});
    result.addAll({'qrCodeImage': qrCodeImage});
    result.addAll({'copiaecola': copyAndPaste});
    result.addAll({'total': total});

    return result;
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'] ?? '',
      createdDateTime: map['createdAt'] != null ? DateTime.parse(map['createdAt'] as String) : null,
      overdueDateTime: DateTime.parse(map['due'] as String),
      items: List<CartItemModel>.from(map['items']?.map((x) => CartItemModel.fromMap(x)) ?? []),
      status: map['status'] ?? '',
      qrCodeImage: map['qrCodeImage'] ?? '',
      copyAndPaste: map['copiaecola'] ?? '',
      total: map['total']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderModel.fromJson(String source) => OrderModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'OrderModel(id: $id, createdDateTime: $createdDateTime, overdueDateTime: $overdueDateTime, items: $items, status: $status, qrCodeImage: $qrCodeImage, copyAndPaste: $copyAndPaste, total: $total)';
  }
}
