import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greengrocer/src/core/config/custom_colors.dart';
import 'package:greengrocer/src/modules/base/base_controller.dart';
import 'package:greengrocer/src/modules/cart/pages/cart_tab.dart';
import 'package:greengrocer/src/modules/home/pages/home_tab.dart';
import 'package:greengrocer/src/modules/orders/pages/orders_tab.dart';
import 'package:greengrocer/src/modules/profile/pages/profile_tab.dart';
import 'package:greengrocer/src/modules/profile/profile_bindings.dart';

class BaseScreen extends StatelessWidget {
  const BaseScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: GetX<BaseController>(
        builder: (controller) {
          return BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart_outlined),
                label: 'Carrinho',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.list),
                label: 'Pedidos',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                label: 'Perfil',
              ),
            ],
            type: BottomNavigationBarType.fixed,
            backgroundColor: CustomColors.customSwatchColor,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white.withAlpha(100),
            currentIndex: controller.pageIndex,
            onTap: controller.goToPage,
          );
        },
      ),
      body: _navigator(),
    );
  }

  Navigator _navigator() {
    return Navigator(
      key: Get.nestedKey(BaseController.NAVIGATOR_KEY),
      initialRoute: '/home',
      onGenerateRoute: (settings) {
        if (settings.name == '/home') {
          return GetPageRoute(
            settings: settings,
            page: () => HomeTab(),
            //binding: HomeBindings(),
            transition: Transition.upToDown,
            transitionDuration: const Duration(milliseconds: 400),
          );
        }
        if (settings.name == '/cart') {
          return GetPageRoute(
            settings: settings,
            page: () => const CartTab(),
            transition: Transition.upToDown,
            transitionDuration: const Duration(milliseconds: 400),
          );
        }
        if (settings.name == '/orders') {
          return GetPageRoute(
            settings: settings,
            page: () => const OrdersTab(),
            //binding: OrdersBindings(),
            transition: Transition.upToDown,
            transitionDuration: const Duration(milliseconds: 400),
          );
        }
        if (settings.name == '/profile') {
          return GetPageRoute(
            settings: settings,
            page: () => const ProfileTab(),
            binding: ProfileBindings(),
            transition: Transition.upToDown,
            transitionDuration: const Duration(milliseconds: 400),
          );
        }
        return null;
      },
    );
  }
}

/* Widget _screens() {
  return GetX<BaseController>(
    builder: (controller) {
      return IndexedStack(
        index: controller.pageIndex,
        children: const [
          HomeTab(),
          CartTab(),
          OrdersTab(),
          ProfileTab(),
        ],
      );
    },
  );
} */
