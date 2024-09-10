import 'package:app_tcareer/src/modules/posts/data/models/post_response.dart';
import 'package:app_tcareer/src/modules/posts/data/models/post_state.dart';
import 'package:app_tcareer/src/modules/posts/presentation/posts_provider.dart';
import 'package:app_tcareer/src/modules/posts/usecases/post_use_case.dart';
import 'package:app_tcareer/src/shared/utils/alert_dialog_util.dart';
import 'package:app_tcareer/src/shared/utils/snackbar_utils.dart';
import 'package:app_tcareer/src/shared/utils/user_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

class PostController extends ChangeNotifier {
  final PostUseCase postUseCase;
  final ChangeNotifierProviderRef<Object?> ref;
  PostController(this.postUseCase, this.ref);
  PostResponse postData = PostResponse();
  bool isLoading = false;
  Future<void> getPost() async {
    setIsLoading(true);
    postData = await postUseCase.getPost();
    setIsLoading(false);
  }

  void setIsLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  Future<void> sharePost({required String url, required String title}) async {
    await Share.share(url, subject: title);
  }

  Future<void> loadCacheImage() async {
    final userUtils = ref.watch(userUtilsProvider);
    final mediaController = ref.watch(mediaControllerProvider);
    List<String>? imageCache = await userUtils.loadCacheList("imageCache");
    if (imageCache?.isNotEmpty == true) {
      mediaController.imagePaths = imageCache!;
    }
    notifyListeners();
  }

  Future<void> showDialog(BuildContext context) async {
    final mediaController = ref.watch(mediaControllerProvider);

    if (mediaController.imagePaths.isEmpty) {
      context.pop();
    } else {
      AlertDialogUtil.showConfirmDialog(
          context: context,
          message: "Bạn có muốn lưu bài viết này dưới dạng nháp không?",
          onConfirm: () {
            showSnackBar(
                context: context, message: "Bài viết đã được lưu thành công");
            context.pop();
            context.goNamed("home");
          },
          onCancel: () async => clearPostCache(context),
          confirmTitle: "Đồng ý");
    }
  }

  Future<void> clearPostCache(BuildContext context) async {
    final mediaController = ref.watch(mediaControllerProvider);
    final userUtils = ref.watch(userUtilsProvider);
    await userUtils.removeCache("imageCache");

    context.pop();
    context.goNamed("home");
    notifyListeners();
  }
}
