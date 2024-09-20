import 'package:app_tcareer/src/modules/posts/usecases/post_use_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommentController extends ChangeNotifier {
  final PostUseCase postUseCase;
  final Ref ref;
  CommentController(this.postUseCase, this.ref);
  TextEditingController contentController = TextEditingController();

  Future<void> postCreateComment({required int postId}) async {
    await postUseCase.postCreateComment(
        postId: postId, content: contentController.text);
  }
}
