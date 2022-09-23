import 'package:get/get.dart';
import 'package:greengrocer/src/core/constants/storage_keys.dart';
import 'package:greengrocer/src/core/mixins/loader_mixin.dart';
import 'package:greengrocer/src/core/services/auth_service.dart';
import 'package:greengrocer/src/core/services/storage_service.dart';
import 'package:greengrocer/src/core/services/utils_service.dart';
import 'package:greengrocer/src/models/user_model.dart';
import 'package:greengrocer/src/pages_routes/app_pages.dart';
import 'package:greengrocer/src/repositories/auth/auth_repository.dart';

class AuthController extends GetxController with LoaderMixin {
  final AuthRepository _authRepository;
  final StorageService _storageService;
  final UtilsService _utilsService;
  final AuthService _authService;

  AuthController({
    required AuthRepository authRepository,
    required StorageService storageService,
    required UtilsService utilsService,
    required AuthService authService,
  })  : _authRepository = authRepository,
        _storageService = storageService,
        _utilsService = utilsService,
        _authService = authService;

  final _loading = false.obs;

  @override
  void onInit() {
    loaderListener(_loading);
    super.onInit();
  }

  Future<void> signIn({required String email, required String password}) async {
    _loading(true);

    var result = await _authRepository.signIn(email: email, password: password);

    _loading(false);

    result.when(
      success: (user) {
        _authService.user = user;
        _saveTokenAndProceedToBase(user.token!);
      },
      error: (message) {
        _utilsService.showToast(message: message, isError: true);
      },
    );
  }

  Future<void> signUp(UserModel user) async {
    _loading(true);

    var result = await _authRepository.signUp(user);

    _loading(false);

    result.when(
      success: (user) {
        _authService.user = user;
        _saveTokenAndProceedToBase(user.token!);
      },
      error: (message) {
        _utilsService.showToast(message: message, isError: true);
      },
    );
  }

  Future<void> resetPassword({required String email}) async {
    await _authRepository.resetPassword(email);
  }

  void _saveTokenAndProceedToBase(String token) {
    _storageService.saveLocalData(key: StorageKeys.token, data: token);

    Get.offAllNamed(PagesRoutes.baseRoute);
  }
}
