import 'dart:io';
import 'dart:typed_data';

import 'package:app_tcareer/src/features/authentication/usecases/login_use_case.dart';
import 'package:app_tcareer/src/features/posts/data/models/create_post_request.dart';
import 'package:app_tcareer/src/features/posts/data/models/post_response.dart';
import 'package:app_tcareer/src/features/posts/data/models/posts_detail_response.dart';
import 'package:app_tcareer/src/features/posts/data/models/posts_response.dart'
    as post;
import 'package:app_tcareer/src/features/posts/data/models/user_liked.dart';
import 'package:app_tcareer/src/features/posts/data/repositories/post_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostUseCase {
  final PostRepository postRepository;
  PostUseCase(this.postRepository);
  Future<post.PostsResponse> getPost(
          {required String personal, String? userId, int? page}) async =>
      await postRepository.getPosts(
          personal: personal, userId: userId, page: page);
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

  Future<void> setLikePost(
      {required int index,
      required String postId,
      required List<post.Data> postCache}) async {
    if (postCache.isNotEmpty && index < postCache.length) {
      final currentPost = postCache[index];
      final isLiked = currentPost.liked ?? false;
      final likeCount = currentPost.likeCount ?? 0;
      final updatedPost = currentPost.copyWith(
          liked: !(postCache[index].liked ?? false),
          likeCount: isLiked ? likeCount - 1 : likeCount + 1);
      postCache[index] = updatedPost;
      final itemList = postCache;

      final itemIndex =
          itemList.indexWhere((post) => post.id == updatedPost.id);
      if (itemIndex != -1) {
        itemList[itemIndex] = updatedPost;
      }
    }
  }

  Future<void> postLikePost(
      {required String postId,
      required int index,
      required List<post.Data> postCache}) async {
    await setLikePost(index: index, postId: postId, postCache: postCache);
    await postRepository.postLikePost(postId);
  }

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

  Future<UserLiked> getUserLikePost(int postId) async {
    return postRepository.getUserLiked(postId: postId);
  }
}

final postUseCaseProvider =
    Provider((ref) => PostUseCase(ref.watch(postRepository)));
