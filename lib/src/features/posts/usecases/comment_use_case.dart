import 'package:app_tcareer/src/features/posts/data/repositories/post_repository.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommentUseCase {
  final PostRepository postRepository;
  CommentUseCase(this.postRepository);

  Future<Map<dynamic, dynamic>?> getCommentByPostId(String postId) async =>
      await postRepository.getCommentByPostId(postId);
  Stream<DatabaseEvent> listenToComment(String postId) =>
      postRepository.listenToComments(postId);
  Future<void> postLikeComment(String commentId) async =>
      await postRepository.postLikeComment(commentId);

  Stream<DatabaseEvent> listenToLikeComment(String postId) =>
      postRepository.listenToLikeComments(postId);
}

final commentUseCaseProvider =
    Provider((ref) => CommentUseCase(ref.watch(postRepository)));
