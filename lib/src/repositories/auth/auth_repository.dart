import 'package:greengrocer/src/models/user_model.dart';
import 'package:greengrocer/src/modules/auth/result/auth_result.dart';

abstract class AuthRepository {
  Future<AuthResult> signIn({required String email, required String password});
  Future<AuthResult> signUp(UserModel user);
  Future<AuthResult> validateToken(String token);
  Future<void> resetPassword(String email);
  Future<bool> changePassword({
    required String token,
    required String email,
    required String currentPassword,
    required String newPassword,
  });
}
