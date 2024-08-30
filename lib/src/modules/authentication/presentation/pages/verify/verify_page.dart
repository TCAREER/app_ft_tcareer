import 'package:app_tcareer/src/modules/authentication/presentation/auth_providers.dart';
import 'package:app_tcareer/src/modules/authentication/presentation/widgets/auth_button_widget.dart';
import 'package:app_tcareer/src/modules/authentication/presentation/widgets/pin_put_widget.dart';

import 'package:app_tcareer/src/shared/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VerifyPage extends ConsumerWidget {
  const VerifyPage({super.key});

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
                  "OTP Verification",
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Enter the verification code we just sent to your email ${controller.textInputController.text}",
                  style: const TextStyle(
                      fontSize: 12, color: Colors.grey, letterSpacing: 1),
                ),
                const SizedBox(
                  height: 20,
                ),
                Form(
                  key: controller.keyVerify,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      pinPutWidget(controller: controller.codeController),
                      const SizedBox(
                        height: 35,
                      ),
                      authButtonWidget(
                          context: context,
                          onPressed: () async => controller.verifyOtp(context),
                          title: "Verify code"),
                      const SizedBox(
                        height: 10,
                      ),
                      RichText(
                          text: TextSpan(
                              text: "Didn’t receive a code? ",
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 12),
                              children: [
                            WidgetSpan(
                                alignment: PlaceholderAlignment.middle,
                                child: InkWell(
                                  onTap: () {},
                                  child: const Text(
                                    "Resend",
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  ),
                                ))
                          ])),
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
