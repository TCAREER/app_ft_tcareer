import 'package:app_tcareer/app.dart';
import 'package:app_tcareer/src/shared/configs/app_constants.dart';
import 'package:app_tcareer/src/modules/authentication/data/models/login_request.dart';
import 'package:app_tcareer/src/modules/authentication/data/models/login_response.dart';
import 'package:app_tcareer/src/modules/authentication/data/models/register_request.dart';
import 'package:app_tcareer/src/shared/utils/app_utils.dart';
import 'package:app_tcareer/src/shared/utils/user_utils.dart';
import 'package:curl_logger_dio_interceptor/curl_logger_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:retrofit/http.dart';

part 'api_services.g.dart';

@RestApi(baseUrl: AppConstants.baseUrl)
abstract class ApiServices {
  factory ApiServices(Dio dio, {String baseUrl}) = _ApiServices;

  @POST('auth/register')
  Future<void> postRegister({@Body() required RegisterRequest body});
  @POST('auth/login')
  Future<LoginResponse> postLogin({@Body() required LoginRequest body});
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
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
  }, onError: (error, handler) {
    handler.reject(error);

    // if (context != null) {
    //   if (error.response?.statusCode != null) {
    //     print(">>>>>>>>>>>>1");
    //     AppUtils.checkExceptionStatusCode(error, context);
    //   } else {
    //     AppUtils.checkException(error, context);
    //     print(">>>>>>>>>>>>2");
    //   }
    // }
    // handler.next(error);
    // throw (error);
  }, onResponse: (response, handler) async {
    if (response.statusCode == 200 && response.data is List<int>) {
      await DefaultCacheManager()
          .putFile(response.requestOptions.uri.toString(), response.data);
    }
    handler.next(response);
  }));

  return ApiServices(dio);
});
