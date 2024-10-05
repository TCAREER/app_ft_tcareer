import 'package:app_tcareer/src/configs/app_colors.dart';
import 'package:app_tcareer/src/features/authentication/presentation/controllers/login_controller.dart';
import 'package:app_tcareer/src/features/authentication/presentation/auth_providers.dart';
import 'package:app_tcareer/src/features/authentication/presentation/widgets/auth_button_widget.dart';
import 'package:app_tcareer/src/features/authentication/presentation/widgets/text_input_form.dart';
import 'package:app_tcareer/src/utils/validator.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart' as firebase_ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sign_in_button/sign_in_button.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(loginControllerProvider);
    if (kDebugMode) {
      controller.phoneController.text = "0771234567";
      controller.passController.text = "12345678aA@";
    }
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
                Text(
                  "Sign in to your\nAccount",
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Enter your email and password to log in ",
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
                        controller: controller.phoneController,
                        // isRequired: true,
                        title: "Phone",
                        hintText: "Enter phone number",
                        validator: Validator.phone,
                      ),
                      TextInputForm(
                        validator: Validator.password,
                        controller: controller.passController,
                        // isRequired: true,
                        isSecurity: true,
                        title: "Password",
                        hintText: "Enter password",
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                            onPressed: () => context.push('/forgotPassword'),
                            child: const Text(
                              "Forgot Password ?",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.titleLogin),
                            )),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      authButtonWidget(
                          context: context,
                          onPressed: () async => controller.onLogin(context),
                          // onPressed:()=>context.goNamed('home'),
                          title: "Continue"),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        child: SignInButton(Buttons.google,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6)),
                            onPressed: () =>
                                controller.signInWithGoogle(context)),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextButton(
                          onPressed: () => context.push('/register'),
                          child: const Text("Create new account",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Color(
                                    0xff494949,
                                  ))))
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
