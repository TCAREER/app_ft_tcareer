import 'package:app_tcareer/src/configs/app_constants.dart';
import 'package:app_tcareer/src/features/authentication/data/models/forgot_password_request.dart';
import 'package:app_tcareer/src/features/authentication/data/models/forgot_password_verify_request.dart';
import 'package:app_tcareer/src/features/authentication/data/models/login_google_request.dart';
import 'package:app_tcareer/src/features/authentication/data/models/login_request.dart';
import 'package:app_tcareer/src/features/authentication/data/models/logout_request.dart';
import 'package:app_tcareer/src/features/authentication/data/models/register_request.dart';
import 'package:app_tcareer/src/features/authentication/data/models/reset_password_request.dart';
import 'package:app_tcareer/src/utils/user_utils.dart';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
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

  Future<void> login({required String phone, required String password}) async {
    try {
      final apiServices = ref.watch(apiServiceProvider);
      final userUtil = ref.watch(userUtilsProvider);
      String deviceToken = await userUtil.getDeviceToken() ?? "";
      String deviceId = await userUtil.getDeviceId() ?? "";
      final body = LoginRequest(
          phone: phone,
          password: password,
          deviceToken: deviceToken,
          deviceId: deviceId);
      final response = await apiServices.postLogin(body: body);
      userUtil.saveAuthToken(
          authToken: response.accessToken ?? "",
          refreshToken: response.refreshToken ?? "");

      // ref.read(isAuthenticatedProvider.notifier).update((state) => true);
    } on DioException catch (e) {
      rethrow;
    }
  }

  Future<void> loginWithGoogle() async {
    final fireBaseAuth = ref.watch(firebaseAuthServiceProvider);
    final user = await fireBaseAuth.signInWithGoogle();
    final accessToken = user?.credential?.accessToken;
    final userUtil = ref.watch(userUtilsProvider);
    String deviceToken = await userUtil.getDeviceToken() ?? "";
    String deviceId = await userUtil.getDeviceId() ?? "";
    try {
      final apiServices = ref.watch(apiServiceProvider);
      final response = await apiServices.postLoginWithGoogle(
          body: LoginGoogleRequest(
              accessToken: accessToken,
              deviceId: deviceId,
              deviceToken: deviceToken));

      userUtil.saveAuthToken(
          authToken: response.accessToken ?? "",
          refreshToken: response.refreshToken ?? "");
    } on DioException catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    final fireBaseAuth = ref.watch(firebaseAuthServiceProvider);
    final userUtil = ref.watch(userUtilsProvider);
    final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    await firebaseMessaging.deleteToken();
    String? deviceToken = await firebaseMessaging.getToken();
    await userUtil.saveDeviceToken(deviceToken: deviceToken ?? "");
    final apiServices = ref.watch(apiServiceProvider);
    String refreshToken = await userUtil.getRefreshToken();
    await apiServices.postLogout(
        body: LogoutRequest(refreshToken: refreshToken));
    await fireBaseAuth.signOut();
    await userUtil.clearToken();
    await userUtil.removeCache("searchHistory");
    await DefaultCacheManager().emptyCache();
  }

  Future<void> forgotPassword(ForgotPasswordRequest body) async {
    final apiServices = ref.watch(apiServiceProvider);
    await apiServices.postForgotPassword(body: body);
  }

  Future<void> forgotPasswordVerify(ForgotPasswordVerifyRequest body) async {
    final apiServices = ref.watch(apiServiceProvider);
    await apiServices.postForgotPasswordVerify(body: body);
  }

  Future<void> resetPassword(
      {required String email, required String password}) async {
    final apiServices = ref.watch(apiServiceProvider);
    await apiServices.postResetPassword(
        body: ResetPasswordRequest(
            email: email,
            password: password,
            key: AppConstants.resetPasswordKey));
  }
}

final authRepository = Provider((ref) => AuthRepository(ref));
