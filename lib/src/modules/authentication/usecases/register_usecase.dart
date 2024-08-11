import 'package:app_tcareer/src/modules/authentication/data/models/register_request.dart';
import 'package:app_tcareer/src/modules/authentication/data/repositories/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegisterUseCase {
  final AuthRepository authRepository;
  RegisterUseCase(this.authRepository);

  Future<void> register(RegisterRequest body) async {
    return await authRepository.register(body);
  }
}

final registerUseCaseProvider = Provider((ref) => ref.watch(authRepository));
