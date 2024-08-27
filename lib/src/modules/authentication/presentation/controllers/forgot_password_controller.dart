import 'package:app_tcareer/src/modules/authentication/data/models/forgot_password_request.dart';
import 'package:app_tcareer/src/modules/authentication/usecases/forgot_password_use_case.dart';
import 'package:app_tcareer/src/shared/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordController extends StateNotifier<void> {
  final ForgotPasswordUseCase forgotPasswordUseCaseProvider;
  ForgotPasswordController(this.forgotPasswordUseCaseProvider) : super(null);

  TextEditingController textInputController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<void> forgotPassword(BuildContext context) async {
    final body = ForgotPasswordRequest(email: textInputController.text);
    if (formKey.currentState?.validate() == true) {
      AppUtils.loadingApi(() async {
        await forgotPasswordUseCaseProvider.forgotPassword(body);
        context.pushNamed('verify');
      }, context);
    }
  }
}
