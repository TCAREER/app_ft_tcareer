import 'package:app_tcareer/app.dart';
import 'package:app_tcareer/src/configs/app_constants.dart';
import 'package:app_tcareer/src/features/authentication/data/models/forgot_password_request.dart';
import 'package:app_tcareer/src/features/authentication/data/models/forgot_password_verify_request.dart';
import 'package:app_tcareer/src/features/authentication/data/models/login_google_request.dart';
import 'package:app_tcareer/src/features/authentication/data/models/refresh_token_request.dart';
import 'package:app_tcareer/src/features/authentication/data/models/reset_password_request.dart';
import 'package:app_tcareer/src/features/authentication/data/models/login_request.dart';
import 'package:app_tcareer/src/features/authentication/data/models/login_response.dart';
import 'package:app_tcareer/src/features/authentication/data/models/register_request.dart';
import 'package:app_tcareer/src/features/posts/data/models/create_comment_request.dart';
import 'package:app_tcareer/src/features/posts/data/models/create_post_request.dart';
import 'package:app_tcareer/src/features/posts/data/models/like_comment_request.dart';
import 'package:app_tcareer/src/features/posts/data/models/like_post_request.dart';
import 'package:app_tcareer/src/features/posts/data/models/post_request.dart';
import 'package:app_tcareer/src/features/posts/data/models/posts_detail_response.dart';
import 'package:app_tcareer/src/features/posts/data/models/posts_response.dart';
import 'package:app_tcareer/src/features/posts/data/models/share_post_request.dart';
import 'package:app_tcareer/src/features/posts/data/models/quick_search_user_data.dart';
import 'package:app_tcareer/src/features/posts/data/models/quick_search_user_request.dart';
import 'package:app_tcareer/src/features/user/data/models/user_data.dart';
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

  @POST("auth/refresh")
  Future<LoginResponse> postRefreshToken(
      {@Body() required RefreshTokenRequest body});
  @POST('auth/forgot_password')
  Future postForgotPassword({@Body() required ForgotPasswordRequest body});

  @POST('auth/forgot_password_verify')
  Future postForgotPasswordVerify(
      {@Body() required ForgotPasswordVerifyRequest body});

  @POST('auth/forgot_password_change')
  Future postResetPassword({@Body() required ResetPasswordRequest body});

  @GET("api/auth/user")
  Future<UserData> getUserInfo();

  @GET("api/auth/user/{id}")
  Future<UserData> getUserById({@Path('id') required String userId});

  @POST('api/auth/create_post')
  Future postCreatePost({@Body() required CreatePostRequest body});

  @GET('api/auth/get_post')
  Future<PostsResponse> getPosts({@Queries() required PostRequest queries});

  @POST('api/auth/like_post')
  Future postLikePost({@Body() required LikePostRequest body});

  @GET('api/auth/post/{id}')
  Future<PostsDetailResponse> getPostById({@Path('id') required String postId});
  


  @POST('api/auth/share_post')
  Future postSharePost({@Body() required SharePostRequest body});

  @POST('api/auth/comment')
  Future postCreateComment({@Body() required CreateCommentRequest body});

  @POST('api/auth/like_comment')
  Future postLikeComment({@Body() required LikeCommentRequest body});

  @GET('api/auth/quick_search_user')
  Future<QuickSearchUserData> getQuickSearchUser(
      {@Query('q') required String query});

}
