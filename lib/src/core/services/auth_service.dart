import 'package:get/get.dart';
import 'package:greengrocer/src/core/constants/storage_keys.dart';
import 'package:greengrocer/src/core/services/storage_service.dart';
import 'package:greengrocer/src/models/user_model.dart';
import 'package:greengrocer/src/pages_routes/app_pages.dart';
import 'package:greengrocer/src/repositories/auth/auth_repository.dart';

class AuthService {
  final AuthRepository _authRepository;
  final StorageService _storageService;

  AuthService({
    required AuthRepository authRepository,
    required StorageService storageService,
  })  : _authRepository = authRepository,
        _storageService = storageService;

  UserModel? user;

  Future<void> validateToken() async {
    String? token = await _storageService.getLocalData(key: StorageKeys.token);

    if (token == null) {
      Get.offAllNamed(PagesRoutes.signInRoute);
      return;
    }

    var result = await _authRepository.validateToken(token);

    result.when(
      success: (user) {
        this.user = user;
        _storageService.saveLocalData(key: StorageKeys.token, data: token);
        Get.offAllNamed(PagesRoutes.baseRoute);
      },
      error: (message) {
        signOut();
        Get.offAllNamed(PagesRoutes.signInRoute);
      },
    );
  }

  Future<void> signOut() async {
    user = null;
    await _storageService.removeLocalData(key: StorageKeys.token);
  }
}
