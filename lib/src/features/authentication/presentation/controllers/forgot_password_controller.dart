import 'package:app_tcareer/src/features/authentication/data/models/forgot_password_request.dart';
import 'package:app_tcareer/src/features/authentication/data/models/forgot_password_verify_request.dart';
import 'package:app_tcareer/src/features/authentication/data/models/reset_password_request.dart';
import 'package:app_tcareer/src/features/authentication/usecases/forgot_password_use_case.dart';
import 'package:app_tcareer/src/utils/app_utils.dart';
import 'package:app_tcareer/src/utils/snackbar_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordController extends StateNotifier<void> {
  final ForgotPasswordUseCase forgotPasswordUseCaseProvider;
  ForgotPasswordController(this.forgotPasswordUseCaseProvider) : super(null);

  TextEditingController textInputController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> keyVerify = GlobalKey<FormState>();
  final GlobalKey<FormState> keyResetPassword = GlobalKey<FormState>();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  Future<void> forgotPassword(BuildContext context) async {
    final body = ForgotPasswordRequest(
      email: textInputController.text,
    );
    if (formKey.currentState?.validate() == true) {
      AppUtils.loadingApi(() async {
        await forgotPasswordUseCaseProvider.forgotPassword(body);
        context.pushNamed('verify');
      }, context);
    }
  }

  Future<void> verifyOtp(BuildContext context) async {
    final body = ForgotPasswordVerifyRequest(
        email: textInputController.text, verifyCode: codeController.text);
    if (keyVerify.currentState?.validate() == true) {
      AppUtils.loadingApi(() async {
        await forgotPasswordUseCaseProvider.forgotPasswordVerify(body);
        context.pushNamed('resetPassword');
        showSnackBar("Xác  thực thành công");
      }, context);
    }
  }

  Future<void> resetPassword(BuildContext context) async {
    if (keyResetPassword.currentState?.validate() == true) {
      AppUtils.loadingApi(() async {
        await forgotPasswordUseCaseProvider.resetPassword(
            email: textInputController.text, password: passwordController.text);
        context.goNamed('login');
        showSnackBar("Cập nhật mật khẩu thành công");
      }, context);
    }
  }
}
