import 'package:get/get.dart';

class BaseController extends GetxController {
  static const NAVIGATOR_KEY = 1;

  final _pages = ['/home', '/cart', '/orders', '/profile'];

  final _pageIndex = 0.obs;

  BaseController();

  int get pageIndex => _pageIndex.value;

  void goToPage(int page) {
    _pageIndex.value = page;

    Get.offNamed(_pages[page], id: NAVIGATOR_KEY);
  }
}
