import 'package:greengrocer/src/core/constants/endpoints.dart';
import 'package:greengrocer/src/core/http_manager/http_manager.dart';
import 'package:greengrocer/src/models/category_model.dart';
import 'package:greengrocer/src/models/item_model.dart';
import 'package:greengrocer/src/modules/home/result/home_result.dart';

import './home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HttpManager _httpManager;

  HomeRepositoryImpl({
    required HttpManager httpManager,
  }) : _httpManager = httpManager;

  @override
  Future<HomeResult<CategoryModel>> getAllCategories() async {
    final result = await _httpManager.restRequest(
      url: Endpoints.getAllCategories,
      method: HttpMethods.post,
    );

    if (result['result'] != null) {
      var data = List<Map<String, dynamic>>.from(result['result']);
      var categories = data.map<CategoryModel>(CategoryModel.fromMap).toList();
      return HomeResult<CategoryModel>.success(categories);
    } else {
      return HomeResult.error('Ocorreu um erro ao buscar as categorias');
    }
  }

  @override
  Future<HomeResult<ItemModel>> getProducts({Map<String, dynamic>? body}) async {
    final result = await _httpManager.restRequest(
      url: Endpoints.getProducts,
      method: HttpMethods.post,
      body: body,
    );

    if (result['result'] != null) {
      var data = List<Map<String, dynamic>>.from(result['result']);
      var products = data.map<ItemModel>(ItemModel.fromMap).toList();
      return HomeResult<ItemModel>.success(products);
    } else {
      return HomeResult.error('Ocorreu um erro ao buscar os produtos');
    }
  }
}
