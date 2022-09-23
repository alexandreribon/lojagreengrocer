import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:add_to_cart_animation/add_to_cart_animation.dart';
import 'package:add_to_cart_animation/add_to_cart_icon.dart';
import 'package:get/get.dart';
import 'package:greengrocer/src/core/config/custom_colors.dart';
import 'package:greengrocer/src/core/constants/navigation_tabs.dart';
import 'package:greengrocer/src/core/ui/common_widgets/app_name_widget.dart';
import 'package:greengrocer/src/core/ui/common_widgets/custom_shimmer.dart';
import 'package:greengrocer/src/modules/base/base_controller.dart';
import 'package:greengrocer/src/modules/cart/cart_controller.dart';
import 'package:greengrocer/src/modules/home/components/category_tile.dart';
import 'package:greengrocer/src/modules/home/components/item_tile.dart';
import 'package:greengrocer/src/modules/home/home_controller.dart';

late Function(GlobalKey) runAddToCartAnimation;

class HomeTab extends GetView<HomeController> {
  HomeTab({Key? key}) : super(key: key);

  final searchEC = TextEditingController();
  final baseController = Get.find<BaseController>();

  final GlobalKey<CartIconKey> globalKeyCartItems = GlobalKey<CartIconKey>();

  void itemSelectedCartAnimation(GlobalKey gkImage) async {
    await runAddToCartAnimation(gkImage);
  }

  @override
  Widget build(BuildContext context) {
    return AddToCartAnimation(
      gkCart: globalKeyCartItems,
      previewDuration: const Duration(milliseconds: 100),
      previewCurve: Curves.ease,
      receiveCreateAddToCardAnimationMethod: (addToCartAnimationMethod) {
        runAddToCartAnimation = addToCartAnimationMethod;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: const AppNameWidget(),
          actions: [
            Padding(
              padding: const EdgeInsets.only(top: 11, right: 16),
              child: GestureDetector(
                onTap: () => baseController.goToPage(NavigationTabs.cart),
                child: GetX<CartController>(
                  builder: (cartController) {
                    return Badge(
                      badgeColor: CustomColors.customContrastColor,
                      badgeContent: Text(
                        cartController.cartTotalItems.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      child: AddToCartIcon(
                        key: globalKeyCartItems,
                        icon: Icon(
                          Icons.shopping_cart,
                          color: CustomColors.customSwatchColor,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            // Campo de Pesquisa
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Obx(() {
                return TextFormField(
                  controller: searchEC,
                  onChanged: (value) {
                    controller.searchTitle = value;
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    isDense: true,
                    hintText: 'Pesquise aqui...',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 14,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: CustomColors.customContrastColor,
                      size: 20,
                    ),
                    suffixIcon: controller.searchTitle.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              searchEC.clear();
                              controller.searchTitle = '';
                              FocusScope.of(context).unfocus();
                            },
                            icon: Icon(
                              Icons.close,
                              size: 21,
                              color: CustomColors.customContrastColor,
                            ),
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(60),
                      borderSide: const BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                  ),
                );
              }),
            ),

            // Categorias
            Obx(
              () => Container(
                padding: const EdgeInsets.only(left: 25),
                height: 40,
                child: !controller.isCatloading ? _listViewCategorias() : _listViewShimmer(),
              ),
            ),

            //Grid de Produtos
            Obx(() {
              return Expanded(
                child: !controller.isPrdLoading
                    ? Visibility(
                        visible: controller.products.isNotEmpty,
                        replacement: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 75,
                              color: CustomColors.customSwatchColor,
                            ),
                            const Text(
                              'Nenhum item encontrado!',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                        child: _gridViewProducts(),
                      )
                    : _gridViewShimmer(),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _listViewCategorias() {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: controller.categories.length,
      separatorBuilder: (_, index) => const SizedBox(width: 10),
      itemBuilder: (_, index) {
        final category = controller.categories[index];
        return Obx(() {
          return CategoryTile(
            category: category.title,
            isSelected: controller.categorySelected.value?.id == category.id,
            onPressed: () => controller.filterByCategory(category, index + 1),
          );
        });
      },
    );
  }

  Widget _listViewShimmer() {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: List.generate(
        10,
        (index) => Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.only(right: 12),
          child: CustomShimmer(
            height: 29,
            width: 80,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }

  GridView _gridViewProducts() {
    return GridView.builder(
      controller: controller.scroll,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 9 / 11.5,
      ),
      itemCount: controller.products.length,
      itemBuilder: (_, index) {
        return ItemTile(
          item: controller.products[index],
          cartAnimationMethod: itemSelectedCartAnimation,
        );
      },
    );
  }

  GridView _gridViewShimmer() {
    return GridView.count(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      physics: const BouncingScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 9 / 11.5,
      children: List.generate(
        10,
        (index) => CustomShimmer(
          height: double.infinity,
          width: double.infinity,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
