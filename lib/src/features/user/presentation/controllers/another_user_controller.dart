import 'package:app_tcareer/src/features/index/index_controller.dart';
import 'package:app_tcareer/src/features/posts/data/models/posts_response.dart'
    as post_model;
import 'package:app_tcareer/src/features/posts/usecases/post_use_case.dart';
import 'package:app_tcareer/src/features/user/data/models/users.dart';
import 'package:app_tcareer/src/features/user/presentation/widgets/another_menu.dart';
import 'package:app_tcareer/src/features/user/usercases/user_use_case.dart';
import 'package:app_tcareer/src/utils/user_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AnotherUserController extends ChangeNotifier {
  final UserUseCase userUseCase;
  final PostUseCase postUseCase;
  final Ref ref;
  AnotherUserController(this.userUseCase, this.postUseCase, this.ref);

  Users? anotherUserData;

  Future<void> getUserById(String userId) async {
    print(">>>>>>>>>>>>userId:$userId");
    anotherUserData = null;
    anotherUserData = await userUseCase.getUserById(userId);
    await getPost(userId);
  }

  bool isLoading = false;
  void setIsLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  post_model.PostsResponse? postData;
  final ScrollController scrollController = ScrollController();
  List<post_model.Data> postCache = [];
  Future<void> getPost(String? userId) async {
    // postCache.clear();
    setIsLoading(true);
    postData =
        await postUseCase.getPost(personal: "p", userId: userId, page: page);
    if (postData?.data != null) {
      final newPosts = postData?.data
          ?.where((newPost) =>
              !postCache.any((cachedPost) => cachedPost.id == newPost.id))
          .toList();
      postCache.addAll(newPosts as Iterable<post_model.Data>);
    }
    setIsLoading(false);
    print(">>>>>>>>>>${postCache.length}");
    notifyListeners();
  }

  bool isLoadingMore = false;
  int page = 1;
  Future<void> loadMore() async {
    // isLoadingMore = true;
    if (!isLoadingMore && postCache.length < (postData?.meta?.total ?? 0)) {
      isLoadingMore = true;
      try {
        page += 1;
        notifyListeners();
        await getPost(anotherUserData?.data?.id.toString() ?? "");
      } finally {
        isLoadingMore = false; // Đặt lại trạng thái
      }
    }
  }

  int pendingLikeCount = 0;
  bool isLikeProcess = false;
  Future<void> postLikePost({
    required int index,
    required String postId,
  }) async {
    if (isLikeProcess) return;
    isLikeProcess = true;
    final currentPost = postCache[index];
    final isLiked = currentPost.liked ?? false;
    final likeCount = currentPost.likeCount ?? 0;
    pendingLikeCount = isLiked ? -1 : 1;
    final updatedPostTemp = currentPost.copyWith(
        liked: !(postCache[index].liked ?? false),
        likeCount: likeCount + pendingLikeCount);

    postCache[index] = updatedPostTemp;
    notifyListeners();
    // setLikePost(index);
    await postUseCase.postLikePost(
        postId: postId, index: index, postCache: postCache);
    isLikeProcess = false;
    notifyListeners();
    pendingLikeCount = 0;
  }

  Future<void> refresh() async {
    // postData?.data?.clear();
    // postCache.clear();
    page = 1;
    // notifyListeners();
    await getUserById(anotherUserData?.data?.id.toString() ?? "");
    await getPost(anotherUserData?.data?.id.toString() ?? "");
  }

  Future<void> logout(BuildContext context) async {
    final userUtils = ref.watch(userUtilsProvider);
    await userUtils.logout(context);
  }

  Future<void> showMenu(BuildContext context) async {
    final index = ref.watch(indexControllerProvider.notifier);
    // index.showBottomSheet(
    //     context: context, builder: (scrollController) => SharePage());
    index.setBottomNavigationBarVisibility(false);

    showModalBottomSheet(
      backgroundColor: Colors.white,
      isScrollControlled: true,
      context: context,
      builder: (context) => SizedBox(
          height: ScreenUtil().screenHeight * .35, child: AnotherMenu()),
    ).whenComplete(
      () => index.setBottomNavigationBarVisibility(true),
    );
  }
}

final anotherUserControllerProvider = ChangeNotifierProvider((ref) {
  final userUseCase = ref.watch(userUseCaseProvider);
  final postUseCase = ref.watch(postUseCaseProvider);
  return AnotherUserController(userUseCase, postUseCase, ref);
});
