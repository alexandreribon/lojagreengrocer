import 'package:get/get.dart';
import 'package:greengrocer/src/modules/auth/auth_bindings.dart';
import 'package:greengrocer/src/modules/auth/pages/sign_in_screen.dart';
import 'package:greengrocer/src/modules/auth/pages/sign_up_screen.dart';
import 'package:greengrocer/src/modules/base/base_bindings.dart';
import 'package:greengrocer/src/modules/base/pages/base_screen.dart';
import 'package:greengrocer/src/modules/cart/cart_bindings.dart';
import 'package:greengrocer/src/modules/home/home_bindings.dart';
import 'package:greengrocer/src/modules/orders/orders_bindings.dart';
import 'package:greengrocer/src/modules/product/product_screen.dart';
import 'package:greengrocer/src/modules/splash/pages/splash_screen.dart';
import 'package:greengrocer/src/modules/splash/splash_bindings.dart';

abstract class AppPages {
  static final pages = <GetPage>[
    GetPage(
      name: PagesRoutes.splashRoute,
      page: () => const SplashScreen(),
      binding: SplashBindings(),
    ),
    GetPage(
      name: PagesRoutes.signInRoute,
      page: () => const SignInScreen(),
      binding: AuthBindings(),
    ),
    GetPage(
      name: PagesRoutes.signUpRoute,
      page: () => SignUpScreen(),
    ),
    GetPage(
      name: PagesRoutes.baseRoute,
      page: () => const BaseScreen(),
      bindings: [
        BaseBindings(),
        HomeBindings(),
        CartBindings(),
        OrdersBindings(),
      ],
    ),
    GetPage(
      name: PagesRoutes.productRoute,
      page: () => ProductScreen(),
    ),
  ];
}

abstract class PagesRoutes {
  static const String splashRoute = '/';
  static const String signInRoute = '/signin';
  static const String signUpRoute = '/signup';
  static const String baseRoute = '/base';
  static const String productRoute = '/product';
}
