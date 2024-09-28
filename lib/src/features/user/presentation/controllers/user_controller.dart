import 'package:app_tcareer/src/features/index/index_controller.dart';
import 'package:app_tcareer/src/features/posts/data/models/posts_response.dart' as post_model;
import 'package:app_tcareer/src/features/posts/usecases/post_use_case.dart';
import 'package:app_tcareer/src/features/user/data/models/users.dart';
import 'package:app_tcareer/src/features/user/usercases/user_use_case.dart';
import 'package:app_tcareer/src/utils/user_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
class UserController extends ChangeNotifier{
  final UserUseCase userUseCase;
  final PostUseCase postUseCase;
  final Ref ref;
  UserController(this.userUseCase,this.postUseCase,this.ref){
    scrollController.addListener(() {
      loadMore();
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        ref
            .read(indexControllerProvider.notifier)
            .setBottomNavigationBarVisibility(false);
      } else if (scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        ref
            .read(indexControllerProvider.notifier)
            .setBottomNavigationBarVisibility(true);
      }
    });
  }

  Users? userData;

  Future<void>getUserInfo()async{

    userData = await userUseCase.getUserInfo();
    notifyListeners();
  }

  Users anotherUserData = Users();
  bool isLoading = false;
  void setIsLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }
  Future<void>getUserById(String userId)async{
    print(">>>>>>>>>>>>userId:$userId");
    setIsLoading(true);
    anotherUserData = await userUseCase.getUserById(userId);
    setIsLoading(false);
    notifyListeners();
  }


  post_model.PostsResponse? postData ;
  final ScrollController scrollController = ScrollController();
  List<post_model.Data> postCache = [];
  Future<void> getPost() async {
    setIsLoading(true);
    postData = await postUseCase.getPost(personal: "p");
    if (postData?.data != null) {
      final newPosts = postData?.data
          ?.where((newPost) =>
      !postCache.any((cachedPost) => cachedPost.id == newPost.id))
          .toList();
      postCache.addAll(newPosts as Iterable<post_model.Data>);
    }
    setIsLoading(false);
    notifyListeners();
  }

  Future<void> loadMore() async {
    if (scrollController.position.maxScrollExtent == scrollController.offset) {
      await getPost();
    }
  }

  void setLikePost(int index) {
    if (postData != null && postCache.isNotEmpty) {
      final updatedPost = postCache[index].copyWith(
        liked: !(postCache[index].liked ?? false),
      );

      postCache[index] = updatedPost;
      final itemList = postCache;

      final itemIndex =
      itemList.indexWhere((post) => post.id == updatedPost.id);
      if (itemIndex != -1) {
        itemList[itemIndex] = updatedPost;
        notifyListeners(); // Thông báo cho PagingController về sự thay đổi
      }

      notifyListeners(); // Thông báo cho widget khác về sự thay đổi
    }
  }
  Future<void> postLikePost(
      {required int index, required String postId}) async {
    setLikePost(index);
    await postUseCase.postLikePost(postId);
  }
  Future<void> refresh() async {
    postData?.data?.clear();
    postCache.clear();

    notifyListeners();
    await getPost();
  }

  Future<void>logout(BuildContext context)async{
    final userUtils = ref.watch(userUtilsProvider);
    await userUtils.logout(context);
  }


  bool isCurrentUser(int userId){
    print(">>>>>>>>>>>isCurrent: ${userData?.data?.id == userId}");
    return userData?.data?.id == userId;
  }



}

final userControllerProvider = ChangeNotifierProvider((ref){
  final userUseCase = ref.watch(userUseCaseProvider);
  final postUseCase = ref.watch(postUseCaseProvider);
  return UserController(userUseCase,postUseCase,ref);
});