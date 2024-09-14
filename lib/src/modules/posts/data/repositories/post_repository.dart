import 'dart:io';
import 'dart:typed_data';

import 'package:app_tcareer/src/configs/app_constants.dart';
import 'package:app_tcareer/src/modules/posts/data/models/create_post_request.dart';
import 'package:app_tcareer/src/modules/posts/data/models/post_response.dart';
import 'package:app_tcareer/src/modules/posts/data/models/posts_response.dart';
import 'package:app_tcareer/src/services/apis/api_service_provider.dart';
import 'package:app_tcareer/src/services/drive/google_drive_service.dart';
import 'package:app_tcareer/src/services/firebase/firebase_storage_service.dart';
import 'package:app_tcareer/src/shared/utils/user_utils.dart';
import 'package:curl_logger_dio_interceptor/curl_logger_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class PostRepository {
  final Ref ref;
  final dio = Dio();
  PostRepository(this.ref);
  Future<PostResponse> getPost() async {
    dio.interceptors.add(CurlLoggerDioInterceptor(printOnSuccess: true));
    dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90));

    PostResponse? data;

    final response =
        await dio.get("https://posts.thiendev.shop/posts", queryParameters: {
      "q": "tech",
    });
    data = PostResponse.fromJson(response.data);
    return data;
  }

  Future<String> uploadImage({
    required File file,
    required String folderPath,
  }) async {
    final firebaseStorage = ref.watch(firebaseStorageServiceProvider);
    return firebaseStorage.uploadFile(file, folderPath);
  }

  Future<String> uploadImageWeb({
    required Uint8List file,
    required String folderPath,
  }) async {
    final firebaseStorage = ref.watch(firebaseStorageServiceProvider);
    return firebaseStorage.uploadPreviewImage(file, folderPath);
  }

  Future<String> uploadFile(
      {required File file,
      required String topic,
      required String folderName}) async {
    final googleDrive = ref.watch(googleDriveServiceProvider);
    return googleDrive.uploadFile(file, topic, folderName);
  }

  Future<String> uploadFileFromUint8List(
      {required Uint8List file,
      required String topic,
      required String folderName}) async {
    final googleDrive = ref.watch(googleDriveServiceProvider);
    return googleDrive.uploadFileFromUint8List(
        file, topic, folderName, "image/jpg");
  }

  Future<void> createPost({required CreatePostRequest body}) async {
    final api = ref.watch(apiServiceProvider);
    await api.postCreatePost(body: body);
  }

  Future<PostsResponse> getPosts({required String personal}) async {
    final api = ref.watch(apiServiceProvider);
    final userUtils = ref.watch(userUtilsProvider);
    print(">>>>>>refreshToken: ${await userUtils.getRefreshToken()}");
    return await api.getPosts(personal: personal);
  }
}

final postRepository = Provider((ref) => PostRepository(ref));
