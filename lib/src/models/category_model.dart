import 'dart:convert';

import 'package:greengrocer/src/models/item_model.dart';

class CategoryModel {
  String id;
  String title;

  List<ItemModel> items;
  int pagination;

  CategoryModel({
    required this.id,
    required this.title,
    required this.items,
    required this.pagination,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'title': title});
    result.addAll({'items': items.map((x) => x.toMap()).toList()});
    result.addAll({'pagination': pagination});

    return result;
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      items: List<ItemModel>.from(map['items']?.map((x) => ItemModel.fromMap(x)) ?? []),
      pagination: map['pagination']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoryModel.fromJson(String source) => CategoryModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CategoryModel(id: $id, title: $title, items: $items, pagination: $pagination)';
  }
}
