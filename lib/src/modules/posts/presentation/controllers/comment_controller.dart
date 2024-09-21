import 'package:app_tcareer/src/modules/posts/usecases/comment_use_case.dart';
import 'package:app_tcareer/src/modules/posts/usecases/post_use_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommentController extends ChangeNotifier {
  final PostUseCase postUseCase;
  final Ref ref;
  final CommentUseCase commentUseCase;
  CommentController(this.postUseCase, this.ref, this.commentUseCase);
  TextEditingController contentController = TextEditingController();

  Future<void> postCreateComment(
      {required int postId, required BuildContext context}) async {
    await postUseCase.postCreateComment(
        postId: postId, content: contentController.text);
    contentController.clear();
    FocusScope.of(context).unfocus();
  }

  bool hasContent = false;
  void setHasContent(String value) {
    if (value.isNotEmpty) {
      hasContent = true;
    } else {
      hasContent = false;
    }
    notifyListeners();
  }

  Map<dynamic, dynamic>? commentData;
  Future<void> getCommentByPostId(String postId) async {
    commentData = await commentUseCase.getCommentByPostId(postId);
    print(">>>>>>>>>>>>>>${commentData}");
    notifyListeners();
  }

  void listenToComments(String postId) {
    commentUseCase.listenToComment(postId).listen((event) {
      if (event.snapshot.value != null) {
        commentData = event.snapshot.value as Map<dynamic, dynamic>;
        notifyListeners();
      }
    });
  }
}

final commentControllerProvider = ChangeNotifierProvider((ref) {
  final postUseCase = ref.read(postUseCaseProvider);
  final commentUseCase = ref.read(commentUseCaseProvider);
  return CommentController(postUseCase, ref, commentUseCase);
});
