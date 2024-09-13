import 'dart:io';

import 'package:app_tcareer/src/modules/posts/data/models/create_post_request.dart';
import 'package:app_tcareer/src/modules/posts/data/models/post_response.dart';
import 'package:app_tcareer/src/modules/posts/data/models/post_state.dart';
import 'package:app_tcareer/src/modules/posts/data/models/posts_response.dart';
import 'package:app_tcareer/src/modules/posts/presentation/controllers/media_controller.dart';
import 'package:app_tcareer/src/modules/posts/presentation/posts_provider.dart';
import 'package:app_tcareer/src/modules/posts/usecases/post_use_case.dart';
import 'package:app_tcareer/src/shared/utils/alert_dialog_util.dart';
import 'package:app_tcareer/src/shared/utils/app_utils.dart';
import 'package:app_tcareer/src/shared/utils/snackbar_utils.dart';
import 'package:app_tcareer/src/shared/utils/user_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';

class PostingController extends ChangeNotifier {
  final PostUseCase postUseCase;
  final ChangeNotifierProviderRef<Object?> ref;
  PostingController(this.postUseCase, this.ref);

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

  Future<void> loadContentCache() async {
    final userUtils = ref.watch(userUtilsProvider);
    String? contentCache = await userUtils.loadCache("postContent");
    if (contentCache != null) {
      contentController.text = contentCache;
      userUtils.removeCache("postContent");
      notifyListeners();
    }
  }

  Future<void> loadPostCache() async {
    await loadContentCache();
    await loadCacheImage();
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

  Future<void> setCacheContent() async {
    final userUtils = ref.watch(userUtilsProvider);
    await userUtils.saveCache(
        key: "postContent", value: contentController.text);
  }

  Future<void> setPostCache(BuildContext context) async {
    final mediaController = ref.read(mediaControllerProvider);
    await setCacheContent();
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
  Future<void> showDialog(BuildContext context) async {
    final mediaController = ref.watch(mediaControllerProvider);

    if (mediaController.imagePaths.isEmpty) {
      Future.microtask(() {
        if (context.canPop()) {
          context.pop();
        }
      });
    } else {
      showModalPopup(
          context: context,
          onSave: () async => await setPostCache(context),
          onDiscard: () async => await clearPostCache(context));
    }
  }

  bool isLoading = false;
  void setIsLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  Future<void> createPost(BuildContext context) async {
    final mediaController = ref.watch(mediaControllerProvider);
    AppUtils.futureApi(() async {
      setIsLoading(true);
      if (mediaController.imagePaths.isNotEmpty) {
        await uploadImage();
      }
      await postUseCase.createPost(
          body: CreatePostRequest(
              body: contentController.text,
              privacy: "public",
              mediaUrl: mediaUrl));
      setIsLoading(false);
      showSnackBar("Tạo bài viết thành công");
      context.pop();
      context.goNamed("home");
    }, context);
  }

  List<String> mediaUrl = [];
  Future<void> uploadImage() async {
    mediaUrl.clear();

    final mediaController = ref.watch(mediaControllerProvider);
    final uuid = Uuid();
    final id = uuid.v4();
    for (String asset in mediaController.imagePaths) {
      String path = "posts/$id";
      String? assetPath = await AppUtils.compressImage(asset);
      // String url = await postUseCase.uploadImage(
      //     file: File(assetPath ?? ""), folderPath: path);
      String url = await postUseCase.uploadFile(
          file: File(assetPath ?? ""), topic: "Posts", folderName: id);
      mediaUrl.add(url);
    }
    notifyListeners();
  }
}
