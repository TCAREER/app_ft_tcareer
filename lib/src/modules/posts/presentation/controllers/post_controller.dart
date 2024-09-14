import 'package:app_tcareer/src/modules/posts/data/models/post_response.dart';
import 'package:app_tcareer/src/modules/posts/data/models/post_state.dart';
import 'package:app_tcareer/src/modules/posts/data/models/posts_response.dart';
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
import 'package:share_plus/share_plus.dart';

class PostController extends ChangeNotifier {
  final PostUseCase postUseCase;
  final ChangeNotifierProviderRef<Object?> ref;
  PostController(this.postUseCase, this.ref);
  PostsResponse postData = PostsResponse();
  bool isLoading = false;
  Future<void> getPost() async {
    setIsLoading(true);
    postData = await postUseCase.getPost(personal: "n");
    setIsLoading(false);
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
  int activeIndexPhotoView = 0;

  void setActiveIndexPhotoView(index) {
    activeIndexPhotoView = index;
    notifyListeners();
  }

  void animatePostImage(String postId) {
    carouselController.animateToPage(activeIndexMap[postId] ?? 0);
    notifyListeners();
  }
}
