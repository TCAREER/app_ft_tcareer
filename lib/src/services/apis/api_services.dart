import 'package:app_tcareer/app.dart';
import 'package:app_tcareer/src/configs/app_constants.dart';
import 'package:app_tcareer/src/modules/authentication/data/models/forgot_password_request.dart';
import 'package:app_tcareer/src/modules/authentication/data/models/forgot_password_verify_request.dart';
import 'package:app_tcareer/src/modules/authentication/data/models/login_google_request.dart';
import 'package:app_tcareer/src/modules/authentication/data/models/reset_password_request.dart';
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
import 'package:retrofit/retrofit.dart';

part 'api_services.g.dart';

@RestApi(baseUrl: AppConstants.baseUrl)
abstract class ApiServices {
  factory ApiServices(Dio dio, {String baseUrl}) = _ApiServices;

  @POST('auth/register')
  Future<void> postRegister({@Body() required RegisterRequest body});

  @POST('auth/login')
  Future<LoginResponse> postLogin({@Body() required LoginRequest body});

  @POST('auth/login_google')
  Future<LoginResponse> postLoginWithGoogle(
      {@Body() required LoginGoogleRequest body});

  @POST('auth/forgot_password')
  Future postForgotPassword({@Body() required ForgotPasswordRequest body});

  @POST('auth/forgot_password_verify')
  Future postForgotPasswordVerify(
      {@Body() required ForgotPasswordVerifyRequest body});

  @POST('auth/forgot_password_change')
  Future postResetPassword({@Body() required ResetPasswordRequest body});
}
