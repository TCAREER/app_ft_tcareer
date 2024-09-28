import 'dart:io';
import 'dart:typed_data';

import 'package:app_tcareer/src/configs/app_constants.dart';
import 'package:app_tcareer/src/features/posts/data/models/create_comment_request.dart';
import 'package:app_tcareer/src/features/posts/data/models/create_post_request.dart';
import 'package:app_tcareer/src/features/posts/data/models/like_comment_request.dart';
import 'package:app_tcareer/src/features/posts/data/models/like_post_request.dart';
import 'package:app_tcareer/src/features/posts/data/models/post_request.dart';
import 'package:app_tcareer/src/features/posts/data/models/post_response.dart';
import 'package:app_tcareer/src/features/posts/data/models/posts_detail_response.dart';
import 'package:app_tcareer/src/features/posts/data/models/posts_response.dart';
import 'package:app_tcareer/src/features/posts/data/models/quick_search_user_data.dart';
import 'package:app_tcareer/src/features/posts/data/models/share_post_request.dart';
import 'package:app_tcareer/src/services/apis/api_service_provider.dart';
import 'package:app_tcareer/src/services/drive/google_drive_service.dart';
import 'package:app_tcareer/src/services/drive/upload_file_service.dart';
import 'package:app_tcareer/src/services/firebase/firebase_database_service.dart';
import 'package:app_tcareer/src/services/firebase/firebase_storage_service.dart';
import 'package:app_tcareer/src/utils/user_utils.dart';

import 'package:curl_logger_dio_interceptor/curl_logger_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class PostRepository {
  final Ref ref;
  final dio = Dio();
  PostRepository(this.ref);

  Future<String> uploadFileFirebase({
    required File file,
    required String folderPath,
  }) async {
    final firebaseStorage = ref.watch(firebaseStorageServiceProvider);
    return firebaseStorage.uploadFile(file, folderPath);
  }

  Future<String> uploadFileFromUint8List({
    required Uint8List file,
    required String folderPath,
  }) async {
    final firebaseStorage = ref.watch(firebaseStorageServiceProvider);
    return firebaseStorage.uploadFileFromUint8List(file, folderPath);
  }

  Future<String> uploadFileFromUint8ListVideo(
      {required Uint8List file,
      required String folderPath,
      bool isPreview = false}) async {
    final firebaseStorage = ref.watch(firebaseStorageServiceProvider);
    return firebaseStorage.uploadFileFromUint8ListVideo(file, folderPath,
        isPreview: isPreview);
  }

  Future<String> uploadFile(
      {File? file,
      Uint8List? uint8List,
      required String topic,
      required String folderName}) async {
    final api = ref.watch(uploadFileServiceProvider);
    return api.uploadFile(
        topic: topic, folderName: folderName, file: file, uint8List: uint8List);
  }

  Future<void> createPost({required CreatePostRequest body}) async {
    final api = ref.watch(apiServiceProvider);
    await api.postCreatePost(body: body);
  }

  Future<PostsResponse> getPosts({required String personal,String? userId}) async {
    final api = ref.watch(apiServiceProvider);
    final userUtils = ref.watch(userUtilsProvider);
    print(">>>>>>refreshToken: ${await userUtils.getRefreshToken()}");
    return await api.getPosts(queries: PostRequest(
      personal: personal,
      profileUserId: userId
    ));
  }

  Future<void> postLikePost(String postId) async {
    final api = ref.watch(apiServiceProvider);
    return api.postLikePost(body: LikePostRequest(postId: postId));
  }

  Future<PostsDetailResponse> getPostById(String postId) async {
    final api = ref.watch(apiServiceProvider);
    return api.getPostById(postId: postId);
  }

  Future<void> postCreateComment(
      {required int postId,
      int? parentId,
      required String content,
      List<String>? mediaUrl}) async {
    final api = ref.watch(apiServiceProvider);
    final body = CreateCommentRequest(
        postId: postId,
        commentId: parentId,
        content: content,
        mediaUrl: mediaUrl);
    return api.postCreateComment(body: body);
  }

  Future<Map<dynamic, dynamic>?> getCommentByPostId(String postId) async {
    final database = ref.watch(firebaseDatabaseServiceProvider);
    String path = "comments/$postId";
    return await database.getData(path);
  }

  Stream<DatabaseEvent> listenToComments(String postId) {
    final database = ref.watch(firebaseDatabaseServiceProvider);
    String path = "comments/$postId";
    return database.listenToData(path);
  }

  Future<void> postLikeComment(String commentId) async {
    final api = ref.watch(apiServiceProvider);
    return api.postLikeComment(
        body: LikeCommentRequest(commentId: num.parse(commentId)));
  }

  Stream<DatabaseEvent> listenToLikeComments(String postId) {
    final database = ref.watch(firebaseDatabaseServiceProvider);
    String path = "likes/$postId";
    return database.listenToData(path);
  }

  Future<void> postSharePost(int postId, String privacy, String body) async {
    final api = ref.watch(apiServiceProvider);
    return await api.postSharePost(
        body: SharePostRequest(postId: postId, privacy: privacy, body: body));
  }

  Future<QuickSearchUserData>getQuickSearchUser(String query)async{
    final api = ref.watch(apiServiceProvider);
    return await api.getQuickSearchUser(query: query);
  }

  Future getSearch(String query)async{
    final api = ref.watch(apiServiceProvider);
    return await api.getSearch(query: query);
  }
}

final postRepository = Provider((ref) => PostRepository(ref));