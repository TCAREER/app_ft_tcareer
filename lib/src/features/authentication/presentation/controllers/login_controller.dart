import 'package:app_tcareer/firebase_options.dart';
import 'package:app_tcareer/src/features/authentication/data/models/login_request.dart';
import 'package:app_tcareer/src/features/authentication/usecases/login_use_case.dart';
import 'package:app_tcareer/src/configs/app_constants.dart';
import 'package:app_tcareer/src/utils/app_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginController extends ChangeNotifier {
  final LoginUseCase loginUseCaseProvider;
  LoginController(this.loginUseCaseProvider);
  TextEditingController phoneController = TextEditingController();
  TextEditingController passController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Future<void> login(BuildContext context,
      {String? phone, String? password}) async {
    AppUtils.loadingApi(() async {
      await loginUseCaseProvider.login(
          phone: phone ?? phoneController.text,
          password: password ?? passController.text);
      context.replaceNamed("login");
      // context.goNamed("home");
    }, context);
  }

  Future<void> onLogin(BuildContext context) async {
    if (formKey.currentState?.validate() == true) {
      await login(context);
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    await loginUseCaseProvider.loginWithGoogle();
    context.replaceNamed("login");

    // context.goNamed("home");
  }
}
