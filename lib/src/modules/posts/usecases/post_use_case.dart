import 'dart:io';

import 'package:app_tcareer/src/modules/authentication/usecases/login_use_case.dart';
import 'package:app_tcareer/src/modules/posts/data/models/post_response.dart';
import 'package:app_tcareer/src/modules/posts/data/repositories/post_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostUseCase {
  final PostRepository postRepository;
  PostUseCase(this.postRepository);
  Future<PostResponse> getPost() async => await postRepository.getPosts();
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
      required String folderName}) async {
    return await postRepository.uploadFile(
        file: file, topic: topic, folderName: folderName);
  }
}

final postUseCaseProvider =
    Provider((ref) => PostUseCase(ref.watch(postRepository)));
