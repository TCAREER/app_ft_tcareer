import 'package:app_tcareer/src/modules/authentication/data/models/refresh_token_request.dart';
import 'package:app_tcareer/src/shared/utils/user_utils.dart';
import 'package:curl_logger_dio_interceptor/curl_logger_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
        "origin": null,
        "accept": "*/*",
        "sec-fetch-mode": "cors",
        "accept-language": "vi,en-US;q=0.9,en;q=0.8",
        ...options.headers,
      };
      handler.next(options);
    }
  }, onError: (error, handler) async {
    final userUtils = ref.read(userUtilsProvider);
    final authToken = await userUtils.getAuthToken();
    print(">>>>>>>>>>>isNull ${authToken != null}");
    if (error.response?.statusCode == 401 && authToken != null) {
      handleRefreshToken(ref, error, handler, dio);
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

Future<void> handleRefreshToken(ProviderRef ref, DioException error,
    ErrorInterceptorHandler handler, Dio dio) async {
  final userUtils = ref.read(userUtilsProvider);
  final refreshToken = await userUtils.getRefreshToken();
  final Dio dioNew = Dio();
  final api = ApiServices(dioNew);
  try {
    final response = await api.postRefreshToken(
        body: RefreshTokenRequest(refreshToken: refreshToken));
    String newAuthToken = response.accessToken ?? "";
    await userUtils.saveAuthToken(
        authToken: newAuthToken, refreshToken: refreshToken);
    final newOptions = error.requestOptions;
    newOptions.headers["Authorization"] = "Bearer $newAuthToken";
    final responseRetry = await dio.request(
      newOptions.path,
      options: Options(
        method: newOptions.method,
        headers: newOptions.headers,
      ),
      data: newOptions.data,
      queryParameters: newOptions.queryParameters,
    );

    handler.resolve(responseRetry);
  } on DioException catch (e) {
    handler.reject(e);
  }
}
