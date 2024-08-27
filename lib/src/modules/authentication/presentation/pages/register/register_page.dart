import 'package:app_tcareer/src/modules/authentication/presentation/auth_providers.dart';
import 'package:app_tcareer/src/modules/authentication/presentation/widgets/auth_button_widget.dart';
import 'package:app_tcareer/src/modules/authentication/presentation/widgets/text_input_form.dart';
import 'package:app_tcareer/src/shared/configs/app_colors.dart';
import 'package:app_tcareer/src/shared/utils/validator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sign_in_button/sign_in_button.dart';

class RegisterPage extends ConsumerWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(registerControllerProvider);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
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
                  "Sign up",
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Create an account to continue!",
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
                          controller: controller.fullNameController,
                          // isRequired: true,
                          title: "Full Name",
                          hintText: "Enter full name",
                          validator: Validator.fullname,
                        ),
                        TextInputForm(
                          controller: controller.emailController,
                          // isRequired: true,
                          title: "Email",
                          hintText: "Enter email",
                          validator: Validator.emailCanEmpty,
                        ),
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

                        const SizedBox(
                          height: 20,
                        ),
                        authButtonWidget(
                            context: context,
                            onPressed: () async => controller.onCreate(context),
                            title: "Register"),

                        const SizedBox(
                          height: 20,
                        ),
                        // SizedBox(
                        //   width: MediaQuery.of(context).size.width,
                        //   height: 50,
                        //   child: SignInButton(Buttons.google,
                        //       shape: RoundedRectangleBorder(
                        //           borderRadius: BorderRadius.circular(6)),
                        //       onPressed: () =>
                        //           controller.signInWithGoogle(context)),
                        // ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
