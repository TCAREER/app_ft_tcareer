import 'dart:io';
import 'dart:typed_data';

import 'package:app_tcareer/src/modules/posts/data/models/create_post_request.dart';
import 'package:app_tcareer/src/modules/posts/data/models/post_response.dart';
import 'package:app_tcareer/src/modules/posts/data/models/post_state.dart';
import 'package:app_tcareer/src/modules/posts/data/models/posts_response.dart';
import 'package:app_tcareer/src/modules/posts/presentation/controllers/media_controller.dart';
import 'package:app_tcareer/src/modules/posts/presentation/posts_provider.dart';
import 'package:app_tcareer/src/modules/posts/usecases/media_use_case.dart';
import 'package:app_tcareer/src/modules/posts/usecases/post_use_case.dart';
import 'package:app_tcareer/src/modules/user/data/models/user_data.dart';
import 'package:app_tcareer/src/modules/user/usercases/user_use_case.dart';
import 'package:app_tcareer/src/shared/utils/alert_dialog_util.dart';
import 'package:app_tcareer/src/shared/utils/app_utils.dart';
import 'package:app_tcareer/src/shared/utils/snackbar_utils.dart';
import 'package:app_tcareer/src/shared/utils/user_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
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
    contentController.clear();
    imagesWeb?.clear();

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

    if (mediaController.imagePaths.isNotEmpty) {
      showModalPopup(
          context: context,
          onSave: () async => await setPostCache(context),
          onDiscard: () async => await clearPostCache(context));
    } else {
      // Future.microtask(() {
      //   if (context.canPop()) {
      context.goNamed("home");
      //   }
      // });
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
      if (mediaController.imagePaths.isNotEmpty) {
        await uploadImage();
      }
      if (imagesWeb?.isNotEmpty == true) {
        await uploadImageFromUint8List();
      }
      if (mediaController.videoPaths.isNotEmpty == true) {
        await uploadVideo();
      }
      await postUseCase.createPost(
          body: CreatePostRequest(
              body: contentController.text,
              privacy: selectedPrivacy,
              mediaUrl: mediaUrl));

      showSnackBar("Tạo bài viết thành công");
      await clearPostCache(context);
      context.pop();
      context.goNamed("home");
    }, context, setIsLoading);
  }

  List<String> mediaUrl = [];
  Future<void> uploadImage() async {
    mediaUrl.clear();
    final mediaController = ref.watch(mediaControllerProvider);
    final uuid = Uuid();
    final id = uuid.v4();
    for (String asset in mediaController.imagePaths) {
      String? assetPath = await AppUtils.compressImage(asset);
      // String url = await postUseCase.uploadImage(
      //     file: File(assetPath ?? ""), folderPath: path);
      String url = await postUseCase.uploadFile(
          file: File(assetPath ?? ""), topic: "Posts", folderName: id);
      mediaUrl.add(url);
    }
    notifyListeners();
  }

  Future<void> uploadVideo() async {
    mediaUrl.clear();
    final mediaController = ref.watch(mediaControllerProvider);
    final uuid = Uuid();
    final id = uuid.v4();
    for (String asset in mediaController.videoPaths) {
      // String url = await postUseCase.uploadImage(
      //     file: File(assetPath ?? ""), folderPath: path);
      String url = await postUseCase.uploadFile(
          file: File(asset ?? ""), topic: "Posts", folderName: id);
      mediaUrl.add(url);
    }
    notifyListeners();
  }

  List<String> mediaPreviewUrl = [];

  String selectedPrivacy = "Public";

  Future<void> selectPrivacy(String privacy, BuildContext context) async {
    selectedPrivacy = privacy;

    context.pop();
    notifyListeners();
  }

  UserData userData = UserData();

  Future<void> getUserInfo() async {
    final userUseCase = ref.watch(userUseCaseProvider);
    userData = await userUseCase.getUserInfo();
    notifyListeners();
  }

  int activeIndex = 0;

  void setActiveIndex(index) {
    activeIndex = index;
    notifyListeners();
  }

  List<Uint8List>? imagesWeb = [];
  Future<void> pickImageWeb() async {
    final mediaUseCase = ref.watch(mediaUseCaseProvider);

    imagesWeb = await mediaUseCase.pickImageWeb();
    print(">>>>>>>>>${imagesWeb?.length}");
    // for (Uint8List asset in imagesWeb!) {
    //   // String? path = await AppUtils.compressImageWeb(asset);
    //   // mediaController.imagePaths.add(path!);
    //   String url =
    //       await postUseCase.uploadImageWeb(file: asset, folderPath: "posts");
    // }

    notifyListeners();
  }

  Future<void> uploadImageFromUint8List() async {
    mediaUrl.clear();

    final uuid = Uuid();
    final id = uuid.v4();
    for (Uint8List asset in imagesWeb!) {
      // String? assetPath = await AppUtils.compressImage(asset);
      // String url = await postUseCase.uploadImage(
      //     file: File(assetPath ?? ""), folderPath: path);
      asset = await AppUtils.compressImageWeb(asset);
      String url = await postUseCase.uploadImageWeb(
          file: asset, folderPath: "Posts/$id");
      mediaUrl.add(url);
    }
    notifyListeners();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    getUserInfo();
  }
}
