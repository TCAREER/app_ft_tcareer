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
  Future<String> uploadImage({
    required File file,
    required String folderPath,
  }) async =>
      await postRepository.uploadImage(
        file: file,
        folderPath: folderPath,
      );

  Future<String> uploadFile(
          {required File file,
          required String topic,
          required String folderName}) async =>
      await postRepository.uploadFile(
          file: file, topic: topic, folderName: folderName);

  Future<String> uploadFileFromUint8List(
          {required Uint8List file,
          required String topic,
          required String folderName}) async =>
      await postRepository.uploadFileFromUint8List(
          file: file, topic: topic, folderName: folderName);

  Future<String> uploadImageWeb({
    required Uint8List file,
    required String folderPath,
  }) async =>
      await postRepository.uploadImageWeb(
        file: file,
        folderPath: folderPath,
      );

  Future<void> createPost({required CreatePostRequest body}) async =>
      await postRepository.createPost(body: body);

  Future<void> postLikePost(String postId) async =>
      await postRepository.postLikePost(postId);
  Future<PostsDetailResponse> getPostById(String postId) async =>
      await postRepository.getPostById(postId);
}

final postUseCaseProvider =
    Provider((ref) => PostUseCase(ref.watch(postRepository)));
