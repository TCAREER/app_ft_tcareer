import 'package:app_tcareer/src/modules/authentication/presentation/controllers/login_controller.dart';
import 'package:app_tcareer/src/modules/authentication/presentation/providers.dart';
import 'package:app_tcareer/src/modules/authentication/presentation/widgets/text_input_form.dart';
import 'package:app_tcareer/src/shared/configs/app_colors.dart';
import 'package:app_tcareer/src/shared/utils/validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart' as firebase_ui;
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
                Column(
                  children: [
                    TextInputForm(
                      controller: controller.phoneController,
                      // isRequired: true,
                      title: "Phone",
                      hintText: "Fill number phone",
                      validator: Validator.phone,
                    ),
                    TextInputForm(
                      validator: Validator.password,
                      controller: controller.passController,
                      // isRequired: true,
                      isSecurity: true,
                      title: "Password",
                      hintText: "Fill password",
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                          onPressed: () {},
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
                    SizedBox(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6)),
                              backgroundColor: AppColors.primary),
                          onPressed: () async => controller.onLogin(context),
                          child: const Text(
                            "LOGIN",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.84),
                          )),
                    ),
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
