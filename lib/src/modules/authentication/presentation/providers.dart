import 'package:app_tcareer/src/modules/authentication/usecases/login_usecase.dart';
import 'package:app_tcareer/src/modules/authentication/presentation/controller/login_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final loginControllerProvider = Provider<LoginController>((ref) {
  final loginUseCaseProvider = ref.watch(loginUseCase);
  return LoginController(loginUseCaseProvider);
});
