import 'package:app_tcareer/src/modules/posts/data/models/post_response.dart';
import 'package:app_tcareer/src/modules/posts/data/models/post_state.dart';
import 'package:app_tcareer/src/modules/posts/data/models/posts_response.dart'
    as post_model;
import 'package:app_tcareer/src/modules/posts/presentation/controllers/media_controller.dart';
import 'package:app_tcareer/src/modules/posts/presentation/posts_provider.dart';
import 'package:app_tcareer/src/modules/posts/usecases/post_use_case.dart';
import 'package:app_tcareer/src/shared/utils/alert_dialog_util.dart';
import 'package:app_tcareer/src/shared/utils/snackbar_utils.dart';
import 'package:app_tcareer/src/shared/utils/user_utils.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:share_plus/share_plus.dart';

class PostController extends ChangeNotifier {
  final PostUseCase postUseCase;
  final ChangeNotifierProviderRef<Object?> ref;
  PostController(this.postUseCase, this.ref) {
    pagingController.addPageRequestListener((pageKey) {
      getPost();
    });
  }
  post_model.PostsResponse? postData;
  bool isLoading = false;
  final PagingController<int, post_model.Data> pagingController =
      PagingController(firstPageKey: 0);

  Future<void> getPost({bool isRefresh = false}) async {
    try {
      if (isRefresh) {
        // Làm mới dữ liệu
        pagingController.itemList?.clear();
        pagingController
            .refresh(); // Chỉ làm mới danh sách, không tải lại dữ liệu từ API
      }

      print("Loading posts");

      postData =
          await postUseCase.getPost(personal: "n"); // API không cần pageKey

      if (postData?.data == null || postData?.data?.isEmpty == true) {
        if (isRefresh) {
          pagingController
              .appendLastPage([]); // Trang cuối khi làm mới mà không có dữ liệu
        } else {
          pagingController.appendLastPage(
              []); // Trang cuối khi tải thêm mà không có dữ liệu
        }
      } else {
        final itemList = pagingController.itemList ?? [];
        final newPosts = postData!.data!
            .where((newPost) => !itemList.any((post) => post.id == newPost.id))
            .toList();

        if (newPosts.isEmpty) {
          pagingController.appendLastPage([]); // Không có dữ liệu mới
        } else {
          if (isRefresh) {
            pagingController.appendPage(
                newPosts, 1); // Reset pageKey và thêm dữ liệu mới
          } else {
            pagingController.appendPage(
                newPosts,
                pagingController.nextPageKey ??
                    1); // Thêm dữ liệu mới và cập nhật pageKey
          }
        }
      }
    } catch (e) {
      pagingController.error = e;
    }
    print(
        "Item list length after getPost: ${pagingController.itemList?.length}");
  }

  void setIsLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  Future<void> sharePost({required String url, required String title}) async {
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
    if (postData != null && postData!.data != null) {
      final updatedPost = postData!.data![index].copyWith(
        liked: !(postData!.data![index].liked ?? false),
      );

      postData!.data![index] = updatedPost;
      final itemList = pagingController.itemList;
      if (itemList != null) {
        final itemIndex =
            itemList.indexWhere((post) => post.id == updatedPost.id);
        if (itemIndex != -1) {
          itemList[itemIndex] = updatedPost;
          pagingController
              .notifyListeners(); // Thông báo cho PagingController về sự thay đổi
        }
      }

      notifyListeners(); // Thông báo cho widget khác về sự thay đổi
    }
  }

  Future<void> postLikePost(
      {required int index, required String postId}) async {
    setLikePost(index);
    await postUseCase.postLikePost(postId);
  }
}
