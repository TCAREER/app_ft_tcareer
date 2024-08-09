import 'package:app_tcareer/src/shared/configs/app_constants.dart';
import 'package:app_tcareer/src/features/authentication/data/models/login_request.dart';
import 'package:app_tcareer/src/features/authentication/data/models/login_response.dart';
import 'package:app_tcareer/src/features/authentication/data/models/register_request.dart';
import 'package:curl_logger_dio_interceptor/curl_logger_dio_interceptor.dart';
import 'package:dio/dio.dart';
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

  return ApiServices(dio);
});
