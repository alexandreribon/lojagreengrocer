import 'package:greengrocer/src/core/constants/endpoints.dart';
import 'package:greengrocer/src/core/http_manager/http_manager.dart';
import 'package:greengrocer/src/models/user_model.dart';
import 'package:greengrocer/src/modules/auth/result/auth_result.dart';
import 'package:greengrocer/src/repositories/auth/auth_errors.dart' as auth_errors;
import 'package:greengrocer/src/repositories/auth/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final HttpManager _httpManager;

  AuthRepositoryImpl({
    required HttpManager httpManager,
  }) : _httpManager = httpManager;

  @override
  Future<AuthResult> signIn({required String email, required String password}) async {
    final result = await _httpManager.restRequest(
      url: Endpoints.signIn,
      method: HttpMethods.post,
      body: {
        'email': email,
        'password': password,
      },
    );

    return _handleUserOrError(result);
  }

  @override
  Future<AuthResult> signUp(UserModel user) async {
    final result = await _httpManager.restRequest(
      url: Endpoints.signUp,
      method: HttpMethods.post,
      body: user.toMap(),
    );

    return _handleUserOrError(result);
  }

  @override
  Future<AuthResult> validateToken(String token) async {
    final result = await _httpManager.restRequest(
      url: Endpoints.validateToken,
      method: HttpMethods.post,
      headers: {
        'X-Parse-Session-Token': token,
      },
    );

    return _handleUserOrError(result);
  }

  @override
  Future<void> resetPassword(String email) async {
    await _httpManager.restRequest(
      url: Endpoints.resetPassword,
      method: HttpMethods.post,
      body: {'email': email},
    );
  }

  @override
  Future<bool> changePassword(
      {required String token,
      required String email,
      required String currentPassword,
      required String newPassword}) async {
    final result = await _httpManager.restRequest(
      url: Endpoints.changePassword,
      method: HttpMethods.post,
      headers: {
        'X-Parse-Session-Token': token,
      },
      body: {
        'email': email,
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      },
    );

    return result['error'] == null;
  }

  AuthResult _handleUserOrError(Map<dynamic, dynamic> result) {
    if (result['result'] != null) {
      final user = UserModel.fromMap(result['result']);
      return AuthResult.success(user);
    } else {
      return AuthResult.error(auth_errors.authErrorsString(result['error']));
    }
  }
}
