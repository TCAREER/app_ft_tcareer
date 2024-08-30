import 'package:app_tcareer/src/modules/authentication/usecases/login_use_case.dart';
import 'package:app_tcareer/src/modules/home/data/models/post_response.dart';
import 'package:app_tcareer/src/modules/home/data/repositories/post_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostUseCase {
  final PostRepository postRepository;
  PostUseCase(this.postRepository);
  Future<PostResponse> getPost() async => await postRepository.getPosts();
}

final postUseCaseProvider =
    Provider((ref) => PostUseCase(ref.watch(postRepository)));
