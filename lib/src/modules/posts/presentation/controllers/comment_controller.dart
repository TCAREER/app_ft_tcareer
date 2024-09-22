import 'package:app_tcareer/src/modules/posts/usecases/comment_use_case.dart';
import 'package:app_tcareer/src/modules/posts/usecases/post_use_case.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommentController extends ChangeNotifier {
  final PostUseCase postUseCase;
  final Ref ref;
  final CommentUseCase commentUseCase;
  CommentController(this.postUseCase, this.ref, this.commentUseCase);
  TextEditingController contentController = TextEditingController();

  Future<void> postCreateComment({
    required int postId,
    required BuildContext context,
  }) async {
    print(">>>>>>>2: $parentId");
    await postUseCase.postCreateComment(
        postId: postId, content: contentController.text, parentId: parentId);
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

  String? hintText;
  int? parentId;
  void setRepComment({required int commentId, required String userName}) {
    hintText = "Đang trả lời $userName";
    parentId = commentId;

    notifyListeners();
  }

  Map<dynamic, dynamic>? commentData;
  Future<void> getCommentByPostId(String postId) async {
    commentData?.clear();
    commentData = await commentUseCase.getCommentByPostId(postId);

    notifyListeners();
  }

  void listenToComments(String postId) {
    commentData?.clear();
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
