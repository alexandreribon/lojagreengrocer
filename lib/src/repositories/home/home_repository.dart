import 'package:greengrocer/src/models/category_model.dart';
import 'package:greengrocer/src/models/item_model.dart';
import 'package:greengrocer/src/modules/home/result/home_result.dart';

abstract class HomeRepository {
  Future<HomeResult<CategoryModel>> getAllCategories();
  Future<HomeResult<ItemModel>> getProducts({Map<String, dynamic>? body});
}
