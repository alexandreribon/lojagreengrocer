import 'package:get/get.dart';
import 'package:greengrocer/src/core/http_manager/http_manager.dart';
import 'package:greengrocer/src/core/services/auth_service.dart';
import 'package:greengrocer/src/core/services/storage_service.dart';
import 'package:greengrocer/src/core/services/utils_service.dart';
import 'package:greengrocer/src/repositories/auth/auth_repository.dart';
import 'package:greengrocer/src/repositories/auth/auth_repository_impl.dart';

class ApplicationBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HttpManager(), fenix: true);
    Get.lazyPut(() => UtilsService(), fenix: true);
    Get.lazyPut(() => StorageService(), fenix: true);
    Get.lazyPut<AuthRepository>(
      () => AuthRepositoryImpl(httpManager: Get.find()),
      fenix: true,
    );
    Get.put(
      AuthService(authRepository: Get.find(), storageService: Get.find()),
      permanent: true,
    );
  }
}
