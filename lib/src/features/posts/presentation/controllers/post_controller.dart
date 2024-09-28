import 'package:app_tcareer/src/features/index/index_controller.dart';
import 'package:app_tcareer/src/features/posts/data/models/post_response.dart';
import 'package:app_tcareer/src/features/posts/data/models/post_state.dart';
import 'package:app_tcareer/src/features/posts/data/models/posts_response.dart'
    as post_model;
import 'package:app_tcareer/src/features/posts/presentation/controllers/media_controller.dart';
import 'package:app_tcareer/src/features/posts/presentation/pages/share_page.dart';
import 'package:app_tcareer/src/features/posts/presentation/posts_provider.dart';
import 'package:app_tcareer/src/features/posts/usecases/comment_use_case.dart';
import 'package:app_tcareer/src/features/posts/usecases/post_use_case.dart';
import 'package:app_tcareer/src/features/user/data/models/users.dart';
import 'package:app_tcareer/src/features/user/usercases/user_use_case.dart';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:share_plus/share_plus.dart';

class PostController extends ChangeNotifier {
  final PostUseCase postUseCase;
  final ChangeNotifierProviderRef<Object?> ref;
  PostController(this.postUseCase, this.ref) {
    scrollController.addListener(() {
      loadMore();

    });
  }
  post_model.PostsResponse? postData;
  bool isLoading = false;

  Users userData = Users();

  Future<void> getUserInfo() async {
    final userUseCase = ref.watch(userUseCaseProvider);
    userData = await userUseCase.getUserInfo();
    notifyListeners();
  }

  void setIsLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  Future<void> shareLink({required String url, required String title}) async {
    await Share.share(url, subject: title);
  }

  Map<String, int> activeIndexMap = {};

  void setActiveIndex({required String postId, required int index}) {
    activeIndexMap[postId] = index;

    notifyListeners();
  }

  int getActiveIndex(String postId) {
    return activeIndexMap[postId] ?? 0;
  }

  PageController pageController = PageController();
  CarouselController carouselController = CarouselController();

  void animatePostImage(String postId) {
    carouselController.animateToPage(activeIndexMap[postId] ?? 0);
    notifyListeners();
  }

  Map<String, bool> likePosts = {};

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

  final ScrollController scrollController = ScrollController();
  List<post_model.Data> postCache = [];
  Future<void> getPost() async {
    postData = await postUseCase.getPost(personal: "n");
    if (postData?.data != null) {
      final newPosts = postData?.data
          ?.where((newPost) =>
              !postCache.any((cachedPost) => cachedPost.id == newPost.id))
          .toList();
      postCache.addAll(newPosts as Iterable<post_model.Data>);
    }
    print(">>>>>>>>>>${postCache.length}");
    notifyListeners();
  }

  Future<void> loadMore() async {
    if (scrollController.position.maxScrollExtent == scrollController.offset) {
      await getPost();
    }
  }

  void scrollToTop() {
    scrollController.jumpTo(0);
    notifyListeners();
  }

  Future<void> refresh() async {
    postData?.data?.clear();
    postCache.clear();
    print(">>>>>>>>>>${postCache.length}");
    notifyListeners();
    await getPost();
  }

  Stream<Map<dynamic, dynamic>> commentsStream(String postId) {
    final commentUseCase = ref.watch(commentUseCaseProvider);
    return commentUseCase.listenToComment(postId).map((event) {
      if (event.snapshot.value != null) {
        final commentMap = event.snapshot.value as Map<dynamic, dynamic>;

        // Sắp xếp bình luận

        // Tạo bản đồ đã sắp xếp
        return commentMap;
      } else {
        return {};
      }
    });
  }

  Future<void> showSharePage(BuildContext context, int postId) async {
    final index = ref.watch(indexControllerProvider.notifier);
    // index.showBottomSheet(
    //     context: context, builder: (scrollController) => SharePage());
    index.setBottomNavigationBarVisibility(false);

    showModalBottomSheet(
      backgroundColor: Colors.white,
      isScrollControlled: true,
      context: context,
      builder: (context) => Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SharePage(postId),
      ),
    );
  }

  TextEditingController shareContentController = TextEditingController();
  Future<void> sharePost(
      {required int postId,
      required String privacy,
      required BuildContext context}) async {
    await postUseCase.postSharePost(
        postId: postId, privacy: privacy, body: shareContentController.text);
    shareContentController.clear();

    FocusScope.of(context).unfocus();
    context.pop();
    scrollController.jumpTo(0);
    await refresh();
  }
}