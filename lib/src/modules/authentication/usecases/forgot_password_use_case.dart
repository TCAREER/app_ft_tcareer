import 'package:app_tcareer/src/modules/authentication/data/models/forgot_password_request.dart';
import 'package:app_tcareer/src/modules/authentication/data/models/forgot_password_verify_request.dart';
import 'package:app_tcareer/src/modules/authentication/data/repositories/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ForgotPasswordUseCase {
  final AuthRepository authRepository;
  ForgotPasswordUseCase(this.authRepository);

  Future<void> forgotPassword(ForgotPasswordRequest body) async {
    return await authRepository.forgotPassword(body);
  }

  Future<void> forgotPasswordVerify(ForgotPasswordVerifyRequest body) async {
    return await authRepository.forgotPasswordVerify(body);
  }
}

final forgotPasswordUseCase =
    Provider((ref) => ForgotPasswordUseCase(ref.watch(authRepository)));
