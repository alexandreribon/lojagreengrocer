import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greengrocer/src/core/services/utils_service.dart';
import 'package:greengrocer/src/models/category_model.dart';
import 'package:greengrocer/src/models/item_model.dart';
import 'package:greengrocer/src/repositories/home/home_repository.dart';

const int itemsPerPage = 6;

class HomeController extends GetxController with ScrollMixin {
  final HomeRepository _homeRepository;
  final UtilsService _utilsService;

  HomeController({
    required HomeRepository homeRepository,
    required UtilsService utilsService,
  })  : _homeRepository = homeRepository,
        _utilsService = utilsService;

  final _isCatLoading = false.obs;
  final _isPrdLoading = false.obs;
  final _categories = <CategoryModel>[].obs;
  final _products = <ItemModel>[].obs;
  final categorySelected = Rxn<CategoryModel>();
  final _searchTitle = ''.obs;
  final _scrollPages = <int>[].obs;

  late final Worker workerPage;
  late final Worker workerSearch;

  var _allProductsOriginal = <ItemModel>[];
  var _allProducts = <ItemModel>[];
  var _allProdPagination = 0;
  var _pageIndex = 0;
  var _filteringByTitle = false;

  IconData tileIcon = Icons.add_shopping_cart_outlined;

  @override
  void onInit() {
    super.onInit();

    workerPage = ever<List<int>>(
      _scrollPages,
      (_) {
        _getScrollProducts();
      },
      condition: () => _scrollPages.elementAt(_pageIndex) > 0,
      //_scrollPages.reduce((previousValue, element) => previousValue + element) > 0,
    );

    workerSearch = debounce<String>(
      _searchTitle,
      (_) => filterByTitle(),
      time: const Duration(milliseconds: 600),
    );
  }

  @override
  void onReady() {
    super.onReady();
    getAllCategories();
    getAllProducts();
  }

  @override
  void onClose() {
    workerPage();
    workerSearch();
    super.onClose();
  }

  @override
  Future<void> onTopScroll() async {}

  @override
  Future<void> onEndScroll() async {
    if (categorySelected.value != null) {
      categorySelected.value!.pagination++;
      _scrollPages[_pageIndex] = categorySelected.value!.pagination;
    } else {
      _allProdPagination++;
      _scrollPages[_pageIndex] = _allProdPagination;
    }
  }

  bool get isCatloading => _isCatLoading.value;
  bool get isPrdLoading => _isPrdLoading.value;

  String get searchTitle => _searchTitle.value;
  set searchTitle(String value) => _searchTitle.value = value;

  List<CategoryModel> get categories => _categories;
  List<ItemModel> get products => _products;

  Future<void> getAllCategories() async {
    _isCatLoading(true);

    var result = await _homeRepository.getAllCategories();

    await 600.milliseconds.delay();

    _isCatLoading(false);

    result.when(
      success: (data) {
        _categories.assignAll(data);
        _scrollPages.addAll(List.generate(_categories.length + 1, (index) => 0));
      },
      error: (message) {
        _utilsService.showToast(message: message, isError: true);
      },
    );
  }

  Future<void> getAllProducts() async {
    _isPrdLoading(true);

    var body = <String, dynamic>{
      'page': null,
      'title': null,
      'categoryId': null,
      'itemsPerPage': 22,
    };

    var result = await _homeRepository.getProducts(body: body);

    await 1.seconds.delay();

    _isPrdLoading(false);

    result.when(
      success: (data) {
        _allProductsOriginal = data;

        var skip = (_allProdPagination * itemsPerPage);
        _allProducts = _allProductsOriginal.skip(skip).take(itemsPerPage).toList();
        _products.assignAll(_allProducts);
      },
      error: (message) {
        _utilsService.showToast(message: message, isError: true);
      },
    );
  }

  void filterByTitle() {
    Get.focusScope?.unfocus();
    _isPrdLoading(true);
    _filteringByTitle = true;
    _assembleFilters();
    _filteringByTitle = false;
    _isPrdLoading(false);
  }

  void filterByCategory(CategoryModel? category, int index) {
    var categoryFilter = category;

    _pageIndex = index;
    if (categoryFilter?.id == categorySelected.value?.id) {
      categoryFilter = null;
      _pageIndex = 0;
    }

    categorySelected.value = categoryFilter;

    _isPrdLoading(true);

    _assembleFilters();

    _isPrdLoading(false);
  }

  void _assembleFilters() {
    if (_filteringByTitle) {
      _allProducts.clear();
      _allProdPagination = 0;
      for (var category in _categories) {
        category.items.clear();
        category.pagination = 0;
      }
      var tempPage = _pageIndex;
      for (var i = 0; i < _scrollPages.length; i++) {
        _pageIndex = i;
        _scrollPages[i] = 0;
      }
      _pageIndex = tempPage;
    }

    if (categorySelected.value != null) {
      if (categorySelected.value!.items.isEmpty) {
        var productsPerCategory = _allProductsOriginal
            .where(
              (p) => p.categoryId == categorySelected.value!.id,
            )
            .toList();

        var skip = (categorySelected.value!.pagination * itemsPerPage);

        if (_searchTitle.isNotEmpty) {
          productsPerCategory = productsPerCategory
              .where(
                (p) => p.itemName.toLowerCase().contains(
                      _searchTitle.toLowerCase(),
                    ),
              )
              .toList();
        }

        categorySelected.value!.items = productsPerCategory.skip(skip).take(itemsPerPage).toList();
      }

      _products.assignAll(categorySelected.value!.items);
    } else {
      if (_allProducts.isEmpty) {
        var skip = (_allProdPagination * itemsPerPage);
        if (_searchTitle.isNotEmpty) {
          var tempProds = _allProductsOriginal
              .where(
                (p) => p.itemName.toLowerCase().contains(
                      _searchTitle.toLowerCase(),
                    ),
              )
              .toList();
          _allProducts = tempProds.skip(skip).take(itemsPerPage).toList();
        } else {
          _allProducts = _allProductsOriginal.skip(skip).take(itemsPerPage).toList();
        }
      }
      _products.assignAll(_allProducts);
    }
  }

  void _getScrollProducts() {
    if (categorySelected.value != null) {
      var productsPerCategory = _allProductsOriginal
          .where(
            (p) => p.categoryId == categorySelected.value!.id,
          )
          .toList();

      if (_searchTitle.isNotEmpty) {
        productsPerCategory = productsPerCategory
            .where(
              (p) => p.itemName.toLowerCase().contains(
                    _searchTitle.toLowerCase(),
                  ),
            )
            .toList();
      }

      var skip = (categorySelected.value!.pagination * itemsPerPage);

      categorySelected.value!.items.addAll(productsPerCategory.skip(skip).take(itemsPerPage));

      _products.assignAll(categorySelected.value!.items);
    } else {
      var skip = (_allProdPagination * itemsPerPage);

      if (_searchTitle.isNotEmpty) {
        var tempProds = _allProductsOriginal
            .where(
              (p) => p.itemName.toLowerCase().contains(
                    _searchTitle.toLowerCase(),
                  ),
            )
            .toList();
        _allProducts.addAll(tempProds.skip(skip).take(itemsPerPage));
      } else {
        _allProducts.addAll(_allProductsOriginal.skip(skip).take(itemsPerPage));
      }

      _products.assignAll(_allProducts);
    }
  }

  Future<void> switchIcon() async {
    tileIcon = Icons.check;
    update();

    await 1500.milliseconds.delay(); //Future.delayed(const Duration(milliseconds: 1500));

    tileIcon = Icons.add_shopping_cart_outlined;
    update();
  }
}
