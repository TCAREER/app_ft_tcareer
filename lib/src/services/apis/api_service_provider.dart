import 'dart:convert';

import 'package:app_tcareer/app.dart';
import 'package:app_tcareer/src/configs/app_constants.dart';
import 'package:app_tcareer/src/modules/authentication/data/models/login_response.dart';
import 'package:app_tcareer/src/modules/authentication/data/models/refresh_token_request.dart';
import 'package:app_tcareer/src/shared/utils/snackbar_utils.dart';
import 'package:app_tcareer/src/shared/utils/user_utils.dart';
import 'package:curl_logger_dio_interceptor/curl_logger_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../services.dart';

final apiServiceProvider = Provider<ApiServices>((ref) {
  final dio = Dio();
  dio.interceptors.add(CurlLoggerDioInterceptor(printOnSuccess: true));
  dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: true,
      maxWidth: 90));
  dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) async {
    var fileResponse =
        await DefaultCacheManager().getFileFromCache(options.uri.toString());
    if (fileResponse != null && fileResponse.file.existsSync()) {
      handler.resolve(Response(
        requestOptions: options,
        statusCode: 200,
        data: await fileResponse.file.readAsBytes(),
      ));
    } else {
      final userUtils = ref.read(userUtilsProvider);
      final authToken = await userUtils.getAuthToken();
      options.headers = {
        "Access-Control-Allow-Origin": "*",
        "Authorization": "Bearer $authToken",
        ...options.headers,
      };
      handler.next(options);
    }
  }, onError: (error, handler) async {
     final userUtils = ref.read(userUtilsProvider);
    if (error.response?.statusCode == 401 && await userUtils.getAuthToken()!=null) {
     
      final refreshToken = await userUtils.getRefreshToken();

      final response = await refreshAccessToken(
          dio: dio, refreshToken: refreshToken, ref: ref);
      await userUtils.saveAuthToken(
          authToken: response?.accessToken ?? "", refreshToken: refreshToken);
      final authToken = await userUtils.getAuthToken();
      final options = error.requestOptions;
      options.headers["Authorization"] = "Bearer $authToken";

      return handler.resolve(await dio.fetch(options));
    } else {
      handler.reject(error);
    }
  }, onResponse: (response, handler) async {
    if (response.statusCode == 200 && response.data is List<int>) {
      await DefaultCacheManager()
          .putFile(response.requestOptions.uri.toString(), response.data);
    }
    handler.next(response);
  }));

  return ApiServices(dio);
});

Future<LoginResponse?> refreshAccessToken(
    {required Dio dio,
    required String refreshToken,
    required ProviderRef ref}) async {
  final LoginResponse? data;

  final refreshTokenNotifier = ref.watch(refreshTokenStateProvider.notifier);
  try {
    dio.options.baseUrl = AppConstants.baseUrl;

    final response = await dio.post('auth/refresh',
        data: RefreshTokenRequest(refreshToken: refreshToken).toJson(),
        options: Options(headers: {
          'Content-Type': 'application/json',
        }));
    data = LoginResponse.fromJson(response.data);
    return data;
  } on DioException catch (err) {
    final userUtils = ref.read(userUtilsProvider);
    if (err.response?.statusCode == 400) {
      userUtils.clearToken();
      refreshTokenNotifier.setTokenExpired(true);
    }
  }
  return null;
}

class RefreshTokenStateNotifier extends ChangeNotifier {
  bool isRefreshTokenExpired = false; // Mặc định là false

  void setTokenExpired(bool expired) {
    isRefreshTokenExpired = expired;
    notifyListeners();
  }
}

final refreshTokenStateProvider = ChangeNotifierProvider(
  (ref) => RefreshTokenStateNotifier(),
);
