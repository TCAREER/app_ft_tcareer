import 'package:app_tcareer/src/features/authentication/presentation/auth_providers.dart';
import 'package:app_tcareer/src/features/authentication/presentation/widgets/auth_button_widget.dart';
import 'package:app_tcareer/src/features/authentication/presentation/widgets/text_input_form.dart';
import 'package:app_tcareer/src/utils/validator.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordPage extends ConsumerWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(forgotPasswordControllerProvider);
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Quên mật khẩu",
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Vui lòng nhập email của bạn để đặt lại mật khẩu ",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(
                  height: 20,
                ),
                Form(
                  key: controller.formKey,
                  child: Column(
                    children: [
                      TextInputForm(
                        controller: controller.textInputController,
                        // isRequired: true,
                        title: "Email",
                        hintText: "Nhập email",
                        validator: Validator.email,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      authButtonWidget(
                          context: context,
                          onPressed: () async =>
                              controller.forgotPassword(context),
                          title: "Gửi mã xác thực"),
                      const SizedBox(
                        height: 20,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
