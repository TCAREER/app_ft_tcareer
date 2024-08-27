import 'package:app_tcareer/src/modules/authentication/data/models/forgot_password_request.dart';
import 'package:app_tcareer/src/modules/authentication/data/models/forgot_password_verify_request.dart';
import 'package:app_tcareer/src/modules/authentication/data/models/login_google_request.dart';
import 'package:app_tcareer/src/modules/authentication/data/models/login_request.dart';
import 'package:app_tcareer/src/modules/authentication/data/models/register_request.dart';
import 'package:app_tcareer/src/shared/utils/user_utils.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../services/services.dart';

class AuthRepository {
  final Ref ref;
  AuthRepository(this.ref);

  Future<void> register(RegisterRequest body) async {
    final apiServices = ref.watch(apiServiceProvider);
    await apiServices.postRegister(body: body);
  }

  Future<void> login(LoginRequest body) async {
    try {
      final apiServices = ref.watch(apiServiceProvider);
      final response = await apiServices.postLogin(body: body);
      final userUtil = ref.watch(userUtilsProvider);
      userUtil.saveAuthToken(authToken: response.accessToken ?? "");

      // ref.read(isAuthenticatedProvider.notifier).update((state) => true);
    } on DioException catch (e) {
      rethrow;
    }
  }

  Future<void> loginWithGoogle() async {
    final firebaseAuthService = ref.watch(firebaseAuthServiceProvider);
    final user = await firebaseAuthService.signInWithGoogle();
    final accessToken = user?.credential?.accessToken;
    try {
      final apiServices = ref.watch(apiServiceProvider);
      final response = await apiServices.postLoginWithGoogle(
          body: LoginGoogleRequest(accessToken: accessToken));
      final userUtil = ref.watch(userUtilsProvider);
      userUtil.saveAuthToken(authToken: response.accessToken ?? "");
    } on DioException catch (e) {
      rethrow;
    }
  }

  Future<void> forgotPassword(ForgotPasswordRequest body) async {
    final apiServices = ref.watch(apiServiceProvider);
    await apiServices.postForgotPassword(body: body);
  }

  Future<void> forgotPasswordVerify(ForgotPasswordVerifyRequest body) async {
    final apiServices = ref.watch(apiServiceProvider);
    await apiServices.postForgotPasswordVerify(body: body);
  }
}

final authRepository = Provider((ref) => AuthRepository(ref));
