import 'package:app_tcareer/firebase_options.dart';
import 'package:app_tcareer/src/modules/authentication/data/models/login_request.dart';
import 'package:app_tcareer/src/modules/authentication/usecases/login_usecase.dart';
import 'package:app_tcareer/src/shared/configs/app_constants.dart';
import 'package:app_tcareer/src/shared/utils/app_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginController extends StateNotifier<void> {
  final LoginUseCase loginUseCaseProvider;
  LoginController(this.loginUseCaseProvider) : super(null);
  TextEditingController phoneController = TextEditingController();
  TextEditingController passController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Future<void> login(BuildContext context) async {
    AppUtils.loadingApi(() async {
      final body = LoginRequest(
          phone: phoneController.text, password: passController.text);
      await loginUseCaseProvider.login(body);

      context.pop();
      context.go("/home");
    }, context);
  }

  Future<void> onLogin(BuildContext context) async {
    if (formKey.currentState?.validate() == true) {
      await login(context);
    }
  }

  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    await auth.signInWithCredential(credential).then((val) async {
      // Map<String, dynamic> data = {
      //   "user": val.user,
      //   "idToken": val.credential?.token,
      //   "token": await val.user?.getIdToken()
      // };

      print("${await val.user?.getIdToken()}");
    });
  }
}
