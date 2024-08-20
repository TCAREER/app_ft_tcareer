import 'package:app_tcareer/src/modules/authentication/data/models/register_request.dart';
import 'package:app_tcareer/src/modules/authentication/usecases/register_use_case.dart';
import 'package:app_tcareer/src/shared/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'login_controller.dart';

class RegisterController extends StateNotifier<void> {
  final RegisterUseCase registerUseCaseProvider;
  final LoginController loginController;
  RegisterController(this.registerUseCaseProvider, this.loginController)
      : super(null);
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<void> createAccount(BuildContext context) async {
    AppUtils.loadingApi(() async {
      final body = RegisterRequest(
          name: fullNameController.text,
          email: emailController.text,
          phone: phoneController.text,
          password: passController.text);
      await registerUseCaseProvider.register(body);
      await loginController.login(context,
          phone: phoneController.text, password: passController.text);
    }, context);
  }

  Future<void> onCreate(BuildContext context) async {
    if (formKey.currentState?.validate() == true) {
      await createAccount(context);
    }
  }
}
