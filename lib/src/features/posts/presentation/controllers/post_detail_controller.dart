import 'package:app_tcareer/src/features/posts/data/models/posts_detail_response.dart'
    as post;
import 'package:app_tcareer/src/features/posts/usecases/post_use_case.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostDetailController extends ChangeNotifier {
  final PostUseCase postUseCase;
  PostDetailController(this.postUseCase);

  post.PostsDetailResponse? postsDetailResponse;
  post.Data? postData;
  Future<void> getPostById(String postId) async {
    postsDetailResponse = null;
    postData = null;
    notifyListeners();
    postsDetailResponse = await postUseCase.getPostById(postId);
    postData = postsDetailResponse?.data;
    notifyListeners();
  }

  Future<void> likePostById(String postId) async {
    await setLikePost();
    Future.delayed(Duration(milliseconds: 1000));
    await postUseCase.postLikePostDetail(postId);

    notifyListeners();
  }

  Future<void> setLikePost() async {
    var currentPost = postData;
    final isLiked = postData?.liked ?? false;
    final likeCount = postData?.likeCount ?? 0;
    if (currentPost != null) {
      final updatePost = currentPost.copyWith(
          liked: !(currentPost.liked ?? false),
          likeCount: isLiked ? likeCount - 1 : likeCount + 1);
      postData = updatePost;
      notifyListeners();
    }
  }
}

final postDetailControllerProvider = ChangeNotifierProvider((ref) {
  final postUseCase = ref.watch(postUseCaseProvider);
  return PostDetailController(postUseCase);
});
