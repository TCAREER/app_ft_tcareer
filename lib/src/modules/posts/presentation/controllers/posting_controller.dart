import 'package:app_tcareer/src/modules/posts/data/models/post_response.dart';
import 'package:app_tcareer/src/modules/posts/data/models/post_state.dart';
import 'package:app_tcareer/src/modules/posts/presentation/controllers/media_controller.dart';
import 'package:app_tcareer/src/modules/posts/presentation/posts_provider.dart';
import 'package:app_tcareer/src/modules/posts/usecases/post_use_case.dart';
import 'package:app_tcareer/src/shared/utils/alert_dialog_util.dart';
import 'package:app_tcareer/src/shared/utils/snackbar_utils.dart';
import 'package:app_tcareer/src/shared/utils/user_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

class PostingController extends ChangeNotifier {
  final PostUseCase postUseCase;
  final ChangeNotifierProviderRef<Object?> ref;
  PostingController(this.postUseCase, this.ref);
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

      notifyListeners();
    }
  }

  Future<void> showDialog(BuildContext context) async {
    final mediaController = ref.watch(mediaControllerProvider);

    if (mediaController.imagePaths.isEmpty) {
      context.pop();
    } else {
      showModalPopup(
          context: context,
          onSave: () async => await setPostCache(context),
          onDiscard: () async => await clearPostCache(context));
    }
  }

  Future<void> clearPostCache(BuildContext context) async {
    final mediaController = ref.watch(mediaControllerProvider);
    final userUtils = ref.watch(userUtilsProvider);
    await userUtils.removeCache("imageCache");
    await userUtils.removeCache("selectedAsset");
    mediaController.selectedAsset.clear();
    mediaController.imagePaths.clear();

    context.goNamed("home");
    notifyListeners();
  }

  Future<void> setCacheImagePath() async {
    final userUtils = ref.watch(userUtilsProvider);
    final mediaController = ref.read(mediaControllerProvider);
    await userUtils.saveCacheList(
        key: "imageCache", value: mediaController.imagePaths);
  }

  Future<void> setPostCache(BuildContext context) async {
    final mediaController = ref.read(mediaControllerProvider);
    await setCacheImagePath();
    await mediaController.setCache();
    showSnackBar("Bài viết đã được lưu làm bản nháp");
    context.goNamed("home");
  }

  void showModalPopup(
      {required BuildContext context,
      required void Function() onSave,
      required void Function() onDiscard}) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: const Text(
            'Bạn có muốn lưu bài viết này dưới dạng nháp?',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          message: const Text('Bài viết sẽ được hiển thị khi bạn quay trở lại'),
          actions: <Widget>[
            CupertinoActionSheetAction(
                onPressed: onSave,
                child: const Text(
                  'Lưu',
                  style: TextStyle(color: Colors.blue),
                )),
            CupertinoActionSheetAction(
                isDestructiveAction: true,
                onPressed: onDiscard,
                child: const Text('Xóa bài viết')),
            CupertinoActionSheetAction(
                child: const Text(
                  'Tiếp tục chỉnh sửa',
                  style: TextStyle(color: Colors.blue),
                ),
                onPressed: () => context.pop()),
          ],
        );
      },
    );
  }

  TextEditingController contentController = TextEditingController();

  Future<void> createPost() async {
    print(">>>>>>>>content: ${contentController.text}");
  }
}
