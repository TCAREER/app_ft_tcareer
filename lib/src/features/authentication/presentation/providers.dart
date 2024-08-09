import 'package:app_tcareer/src/features/authentication/usecases/login_usecase.dart';
import 'package:app_tcareer/src/features/authentication/presentation/controller/login_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final loginControllerProvider =
    StateNotifierProvider<LoginController, AuthState>((ref) {
  final loginUseCaseProvider = ref.watch(loginUseCase);
  return LoginController(loginUseCaseProvider);
});

final isAuthenticatedProvider = StateProvider<bool>((ref) => false);
