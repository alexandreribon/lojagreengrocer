import 'package:get/get.dart';
import 'package:greengrocer/src/core/services/auth_service.dart';

class SplashController extends GetxController {
  final AuthService _authService;

  SplashController({
    required AuthService authService,
  }) : _authService = authService;

  @override
  void onReady() {
    super.onReady();

    Future.delayed(const Duration(seconds: 1), () {
      //Get.offAllNamed(PagesRoutes.signInRoute);
      _authService.validateToken();
    });
  }
}
