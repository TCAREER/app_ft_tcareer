import 'package:app_tcareer/src/features/authentication/presentation/controller/login_controller.dart';
import 'package:app_tcareer/src/features/authentication/presentation/providers.dart';
import 'package:app_tcareer/src/features/authentication/presentation/widgets/text_input_form.dart';
import 'package:app_tcareer/src/shared/configs/app_colors.dart';
import 'package:app_tcareer/src/shared/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(loginControllerProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Center(
                child: Text(
                  "Welcome Back",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: AppColors.titleLogin),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Form(
                  key: controller.formKey,
                  child: Column(
                    children: [
                      TextInputForm(
                        controller: controller.phoneController,
                        isRequired: true,
                        title: "Phone",
                        hintText: "Fill number phone",
                        validator: Validator.phone,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextInputForm(
                        validator: Validator.password,
                        controller: controller.passController,
                        isRequired: true,
                        isSecurity: true,
                        title: "Password",
                        hintText: "Fill password",
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                            onPressed: () {},
                            child: Text(
                              "Forgot Password ?",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.titleLogin),
                            )),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .75,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 20),
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
                      )
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
