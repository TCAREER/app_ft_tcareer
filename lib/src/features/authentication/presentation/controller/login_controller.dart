import 'package:app_tcareer/src/features/authentication/data/models/login_request.dart';
import 'package:app_tcareer/src/features/authentication/usecases/login_usecase.dart';
import 'package:app_tcareer/src/shared/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

enum AuthState { unauthenticated, authenticating, success }

class LoginController extends StateNotifier<AuthState> {
  final LoginUseCase loginUseCaseProvider;
  LoginController(this.loginUseCaseProvider) : super(AuthState.unauthenticated);
  TextEditingController phoneController = TextEditingController();
  TextEditingController passController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<void> login(BuildContext context) async {
    state = AuthState.authenticating;

    try {
      AppUtils.showLoading(context);

      final body = LoginRequest(
          phone: phoneController.text, password: passController.text);
      await loginUseCaseProvider.login(body);
      state = AuthState.success;

      context.pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Đăng nhập thành công"),
          showCloseIcon: true,
        ),
      );
    } catch (e) {
      state = AuthState.unauthenticated;
    }
  }

  Future<void> onLogin(BuildContext context) async {
    if (formKey.currentState?.validate() == true) {
      await login(context);
    }
  }
}
