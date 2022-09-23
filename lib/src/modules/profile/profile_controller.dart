import 'package:get/get.dart';
import 'package:greengrocer/src/core/constants/navigation_tabs.dart';
import 'package:greengrocer/src/core/services/auth_service.dart';
import 'package:greengrocer/src/core/services/utils_service.dart';
import 'package:greengrocer/src/modules/base/base_controller.dart';
import 'package:greengrocer/src/pages_routes/app_pages.dart';
import 'package:greengrocer/src/repositories/auth/auth_repository.dart';

class ProfileController extends GetxController {
  final AuthService _authService;
  final AuthRepository _authRepository;
  final UtilsService _utilsService;

  ProfileController({
    required AuthService authService,
    required AuthRepository authRepository,
    required UtilsService utilsService,
  })  : _authService = authService,
        _authRepository = authRepository,
        _utilsService = utilsService;

  final _isLoading = false.obs;

  AuthService get authService => _authService;
  bool get isLoading => _isLoading.value;

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    _isLoading(true);

    final result = await _authRepository.changePassword(
      token: _authService.user!.token!,
      email: _authService.user!.email!,
      currentPassword: currentPassword,
      newPassword: newPassword,
    );

    _isLoading(false);

    if (result) {
      _utilsService.showToast(message: 'A senha foi alterada com sucesso!');
      await 1500.milliseconds.delay();
      signOut();
    } else {
      _utilsService.showToast(message: 'A senha atual está incorreta', isError: true);
    }
  }

  Future<void> signOut() async {
    final baseController = Get.find<BaseController>();
    baseController.goToPage(NavigationTabs.home);
    await _authService.signOut();
    Get.offAllNamed(PagesRoutes.splashRoute, predicate: (_) => false);
  }
}
