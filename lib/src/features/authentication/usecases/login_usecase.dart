import 'package:app_tcareer/src/features/authentication/data/models/login_request.dart';
import 'package:app_tcareer/src/features/authentication/data/models/login_response.dart';
import 'package:app_tcareer/src/features/authentication/data/repositories/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginUseCase {
  final AuthRepository authRepository;
  LoginUseCase(this.authRepository);

  Future login(LoginRequest body) async {
    return await authRepository.login(body);
  }
}

final loginUseCase = Provider((ref) => LoginUseCase(ref.watch(authRepository)));
