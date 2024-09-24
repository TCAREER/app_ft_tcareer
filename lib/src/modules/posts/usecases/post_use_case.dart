import 'dart:io';
import 'dart:typed_data';

import 'package:app_tcareer/src/modules/authentication/usecases/login_use_case.dart';
import 'package:app_tcareer/src/modules/posts/data/models/create_post_request.dart';
import 'package:app_tcareer/src/modules/posts/data/models/post_response.dart';
import 'package:app_tcareer/src/modules/posts/data/models/posts_detail_response.dart';
import 'package:app_tcareer/src/modules/posts/data/models/posts_response.dart';
import 'package:app_tcareer/src/modules/posts/data/repositories/post_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostUseCase {
  final PostRepository postRepository;
  PostUseCase(this.postRepository);
  Future<PostsResponse> getPost({required String personal}) async =>
      await postRepository.getPosts(personal: personal);
  Future<String> uploadFileFireBase({
    required File file,
    required String folderPath,
  }) async =>
      await postRepository.uploadFileFirebase(
        file: file,
        folderPath: folderPath,
      );

  Future<String> uploadFile(
          {File? file,
          Uint8List? uint8List,
          required String topic,
          required String folderName}) async =>
      await postRepository.uploadFile(
          file: file,
          topic: topic,
          folderName: folderName,
          uint8List: uint8List);

  Future<String> uploadFileFromUint8List({
    required Uint8List file,
    required String folderPath,
  }) async =>
      await postRepository.uploadFileFromUint8List(
        file: file,
        folderPath: folderPath,
      );

  Future<String> uploadFileFromUint8ListPreview(
          {required Uint8List file,
          required String folderPath,
          bool isPreview = false}) async =>
      await postRepository.uploadFileFromUint8ListVideo(
          file: file, folderPath: folderPath, isPreview: isPreview);

  Future<void> createPost({required CreatePostRequest body}) async =>
      await postRepository.createPost(body: body);

  Future<void> postLikePost(String postId) async =>
      await postRepository.postLikePost(postId);
  Future<PostsDetailResponse> getPostById(String postId) async =>
      await postRepository.getPostById(postId);

  Future<void> postCreateComment(
          {required int postId,
          int? parentId,
          required String content,
          List<String>? mediaUrl}) async =>
      await postRepository.postCreateComment(
          postId: postId,
          content: content,
          mediaUrl: mediaUrl,
          parentId: parentId);

  Future<void> postSharePost(
      {required int postId,
      required String privacy,
      required String body}) async {
    return postRepository.postSharePost(postId, privacy, body);
  }
}

final postUseCaseProvider =
    Provider((ref) => PostUseCase(ref.watch(postRepository)));
