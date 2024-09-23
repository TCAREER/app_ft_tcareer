import 'dart:io';
import 'dart:typed_data';

import 'package:app_tcareer/src/modules/posts/data/models/media_state.dart';
import 'package:app_tcareer/src/modules/posts/presentation/controllers/comment_controller.dart';
import 'package:app_tcareer/src/modules/posts/presentation/controllers/post_controller.dart';
import 'package:app_tcareer/src/modules/posts/presentation/pages/posting_page.dart';
import 'package:app_tcareer/src/modules/posts/presentation/posts_provider.dart';
import 'package:app_tcareer/src/modules/posts/usecases/media_use_case.dart';
import 'package:app_tcareer/src/shared/utils/snackbar_utils.dart';
import 'package:app_tcareer/src/shared/utils/user_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class MediaController extends ChangeNotifier {
  final MediaUseCase mediaUseCase;
  MediaController(this.mediaUseCase, this.ref);
  final ChangeNotifierProviderRef<Object?> ref;
  bool permissionGranted = false;
  List<AssetPathEntity> albums = [];
  List<AssetEntity> media = [];
  AssetPathEntity? selectedAlbum;

  Future<bool> requestPermission() async =>
      await mediaUseCase.requestPermission();

  Future<void> getAlbums() async {
    bool isPermission = await requestPermission();
    if (isPermission) {
      albums = await mediaUseCase.getAlbums();

      selectedAlbum = albums.first;
      notifyListeners();
      if (media.isEmpty) {
        await getMediaFromAlbum(albums.first);
      }
    }
  }

  Future<void> getMediaFromAlbum(AssetPathEntity album) async {
    media = await mediaUseCase.getMediaFromAlbum(album: album);
    await prefetchVideoDurations();
    notifyListeners();
  }

  Future<void> selectAlbum(album) async {
    selectedAlbum = album;
    await getMediaFromAlbum(selectedAlbum!);
    setIsShowPopUp(false);
    notifyListeners();
  }

  Map<String, Uint8List?> cachedThumbnails = {};

  bool isShowPopUp = false;

  void setIsShowPopUp(bool value) {
    isShowPopUp = value;
    notifyListeners();
  }

  bool isAutoPop = false;
  Future<void> clearData(BuildContext context) async {
    bool hasChanged = await hasChangedSelectedAssets();
    if (isAutoPop) {
      return;
    }
    if (selectedAsset.isEmpty ||
        !hasChanged ||
        imagePaths.length == selectedAsset.length) {
      context.pop();
    } else {
      showModalPopup(
          context: context,
          onPop: () async {
            // selectedAsset.clear();
            // assetIndices.clear();
            Future.microtask(() {
              selectedAsset.clear();
              context.pop();
              context.pop();
            });
          });
    }
  }

  List<String> imagePaths = [];
  String? videoPaths;

  Future<void> getAssetPaths(BuildContext context) async {
    final userUtils = ref.watch(userUtilsProvider);
    await userUtils.removeCache("selectedAsset");
    await userUtils.removeCache("imageCache");

    imagePaths.clear();
    // Clear videoPaths as well

    for (AssetEntity asset in selectedAsset) {
      File? file = await asset.file;
      if (file != null) {
        if (asset.type == AssetType.image) {
          imagePaths.add(file.path);
        } else if (asset.type == AssetType.video) {
          videoPaths = file.path;
          await generateVideoThumbnail();
        }
      }
    }

    notifyListeners();
    print("Image Paths: $imagePaths");
    print("Video Paths: $videoPaths");
    isAutoPop = true;
    context.pop();
  }

  void resetAutoPop() {
    isAutoPop = false;
  }

  Map<String, Duration?> cachedVideoDurations = {};

  Future<void> prefetchVideoDurations() async {
    for (var item in media) {
      if (item.type == AssetType.video) {
        final duration = await getVideoDuration(item);
        cachedVideoDurations[item.id] = duration;
      }
    }
    print(">>>>>>>>>>$cachedVideoDurations");
    notifyListeners();
  }

  Future<Duration?> getVideoDuration(AssetEntity asset) async {
    if (asset.type == AssetType.video) {
      return asset.videoDuration;
    }
    return null;
  }

  List<AssetEntity> selectedAsset = [];
  List<int> assetIndices = [];
  Future<void> addAsset({
    required AssetEntity asset,
    required BuildContext context,
    bool? isComment,
  }) async {
    print(">>>>>>>>>$isComment");
    if (isComment != false &&
        selectedAsset.length == 1 &&
        !selectedAsset.contains(asset)) {
      showSnackBarError("Bạn chỉ có thể chọn tối đa 1 ảnh hoặc 1 video");
      return;
    }

    if (asset.type == AssetType.video &&
        selectedAsset.any((a) => a.type == AssetType.image)) {
      showSnackBarError("Bạn chỉ có thể chọn tối đa 10 ảnh hoặc 1 video");
      return;
    }
    if (selectedAsset.any(
        (a) => a.type == AssetType.video && !selectedAsset.contains(asset))) {
      showSnackBarError("Bạn đã chọn 1 video, không thể chọn thêm ảnh.");
      return;
    }
    if (asset.type == AssetType.image) {
      if (selectedAsset.length >= 10 && !selectedAsset.contains(asset)) {
        showSnackBarError("Bạn chỉ có thể chọn tối đa là 10 ảnh");
        return;
      }
    } else if (asset.type == AssetType.video) {
      final videoFile = await asset.file; // Lấy file video
      if (videoFile != null) {
        final videoSize = await videoFile.length();
        if (videoSize > 30 * 1024 * 1024) {
          showSnackBarError("Video phải có kích thước dưới 30MB");
          return;
        }
      }

      if (selectedAsset.length >= 10 && !selectedAsset.contains(asset)) {
        showSnackBarError("Bạn chỉ có thể chọn tối đa là 10 ảnh hoặc 1 video");
        return;
      } else if (selectedAsset
              .where((a) => a.type == AssetType.video)
              .isNotEmpty &&
          !selectedAsset.contains(asset)) {
        showSnackBarError("Bạn chỉ có thể chọn tối đa là 1 video");
        return;
      }
    }

    if (selectedAsset.contains(asset)) {
      selectedAsset.remove(asset);
    } else {
      selectedAsset.add(asset);
    }

    // Cập nhật chỉ số của các tài sản đã chọn
    assetIndices =
        selectedAsset.map((asset) => selectedAsset.indexOf(asset)).toList();

    notifyListeners();
  }

  Future<void> setCacheSelectedAssets() async {
    final userUtils = ref.watch(userUtilsProvider);
    List<String> assetIds = selectedAsset.map((asset) => asset.id).toList();
    await userUtils.saveCacheList(key: "selectedAsset", value: assetIds);
  }

  Future<void> loadSelectedAsset() async {
    final userUtils = ref.watch(userUtilsProvider);
    List<String>? assetIds = await userUtils.loadCacheList("selectedAsset");
    if (assetIds != null) {
      selectedAsset.clear();
      for (String id in assetIds) {
        AssetEntity? asset = await AssetEntity.fromId(id);
        if (asset != null) {
          selectedAsset.add(asset);
        }
      }
      notifyListeners();
    }
  }

  Future<void> setCache() async {
    await setCacheSelectedAssets();
  }

  Future<void> loadCache() async {
    await loadSelectedAsset();
    await loadAssetIndices();
  }

  Future<void> loadAssetIndices() async {
    assetIndices =
        selectedAsset.map((asset) => selectedAsset.indexOf(asset)).toList();
    notifyListeners();
  }

  void showModalPopup({
    required BuildContext context,
    required void Function() onPop,
  }) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: const Text(
            'Bỏ thay đổi?',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          message: const Text('Nếu quay lại sẽ bỏ những thay đổi đã thực hiện'),
          actions: <Widget>[
            CupertinoActionSheetAction(
                isDestructiveAction: true,
                onPressed: onPop,
                child: const Text(
                  'Quay lại',
                )),
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

  Future<void> removeAssets() async {
    imagePaths.clear();
    videoPaths = null;
    videoThumbnail = null;
    selectedAsset.clear();
    notifyListeners();
  }

  String? videoThumbnail;
  Future<void> generateVideoThumbnail() async {
    videoThumbnail = await VideoThumbnail.thumbnailFile(
        video: videoPaths ?? "",
        thumbnailPath: (await getTemporaryDirectory()).path,
        imageFormat: ImageFormat.JPEG,
        quality: 100);
  }

  Future<bool> hasChangedSelectedAssets() async {
    final userUtils = ref.watch(userUtilsProvider);
    List<String>? assetIds = await userUtils.loadCacheList("selectedAsset");
    return assetIds?.length != selectedAsset.length;
  }
}
