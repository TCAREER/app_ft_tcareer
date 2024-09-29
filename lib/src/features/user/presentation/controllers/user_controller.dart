import 'package:app_tcareer/src/features/index/index_controller.dart';
import 'package:app_tcareer/src/features/posts/data/models/posts_response.dart'
    as post_model;
import 'package:app_tcareer/src/features/posts/usecases/post_use_case.dart';
import 'package:app_tcareer/src/features/user/data/models/users.dart';
import 'package:app_tcareer/src/features/user/usercases/user_use_case.dart';
import 'package:app_tcareer/src/utils/user_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserController extends ChangeNotifier {
  final UserUseCase userUseCase;
  final PostUseCase postUseCase;
  final Ref ref;
  UserController(this.userUseCase, this.postUseCase, this.ref) {
    // scrollController.addListener(() {
    //   loadMore();
    // });
  }

  Users? userData;

  Future<void> getUserInfo() async {
    userData = await userUseCase.getUserInfo();
    notifyListeners();
  }

  Users anotherUserData = Users();
  bool isLoading = false;
  void setIsLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  Future<void> getUserById(String userId) async {
    print(">>>>>>>>>>>>userId:$userId");
    setIsLoading(true);
    anotherUserData = await userUseCase.getUserById(userId);
    setIsLoading(false);
    notifyListeners();
  }

  post_model.PostsResponse? postData;
  final ScrollController scrollController = ScrollController();
  List<post_model.Data> postCache = [];
  int page = 1;
  Future<void> getPost() async {
    postData = await postUseCase.getPost(personal: "p", page: page);
    if (postData?.data != null) {
      final newPosts = postData?.data
          ?.where((newPost) =>
              !postCache.any((cachedPost) => cachedPost.id == newPost.id))
          .toList();
      postCache.addAll(newPosts as Iterable<post_model.Data>);
    }
    print(">>>>>>>>>postLength: ${postCache.length}");
    print(">>>>>>>>>>>>page: $page");
    notifyListeners();
  }

  bool isLoadingMore = false;
  Future<void> loadMore() async {
    // isLoadingMore = true;
    if (!isLoadingMore && postCache.length < (postData?.meta?.total ?? 0)) {
      isLoadingMore = true;
      try {
        page += 1;
        notifyListeners();
        await getPost();
      } finally {
        isLoadingMore = false; // Đặt lại trạng thái
      }
    }
  }

  Future<void> postLikePost(
      {required int index, required String postId}) async {
    await postUseCase.postLikePost(
        postId: postId, index: index, postCache: postCache);

    notifyListeners();
  }

  Future<void> refresh() async {
    page = 1;
    postData?.data?.clear();
    postCache.clear();

    notifyListeners();
    await getPost();
  }

  Future<void> logout(BuildContext context) async {
    final userUtils = ref.watch(userUtilsProvider);
    await userUtils.logout(context);
  }

  bool isCurrentUser(int userId) {
    print(">>>>>>>>>>>isCurrent: ${userData?.data?.id == userId}");
    return userData?.data?.id == userId;
  }
}

final userControllerProvider = ChangeNotifierProvider((ref) {
  final userUseCase = ref.watch(userUseCaseProvider);
  final postUseCase = ref.watch(postUseCaseProvider);
  return UserController(userUseCase, postUseCase, ref);
});
