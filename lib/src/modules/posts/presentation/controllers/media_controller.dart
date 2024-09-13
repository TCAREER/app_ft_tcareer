import 'dart:io';
import 'dart:typed_data';

import 'package:app_tcareer/src/modules/posts/data/models/media_state.dart';
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
import 'package:photo_manager/photo_manager.dart';

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

  Future<void> clearData(BuildContext context) async {
    bool hasChanged = await hasChangedSelectedAssets();
    if (selectedAsset.isEmpty ||
        !hasChanged ||
        imagePaths.length == selectedAsset.length) {
      Future.microtask(() {
        if (context.canPop()) {
          context.pop();
        }
      });
    } else {
      showModalPopup(
          context: context,
          onPop: () async {
            // selectedAsset.clear();
            // assetIndices.clear();
            Future.microtask(() {
              if (context.canPop()) {
                // context.pop();
                context.pushReplacementNamed("posting");
              }
            });
          });
    }
  }

  List<String> imagePaths = [];
  Future<void> getImagePaths(BuildContext context) async {
    final userUtils = ref.watch(userUtilsProvider);
    await userUtils.removeCache("selectedAsset");
    await userUtils.removeCache("imageCache");

    imagePaths.clear();
    for (AssetEntity asset in selectedAsset) {
      File? file = await asset.file;
      if (file != null) {
        imagePaths.add(file.path);
      }
    }

    notifyListeners();
    print(">>>>>>>>$selectedAsset");
    context.replaceNamed("posting");
  }

  List<AssetEntity> selectedAsset = [];
  List<int> assetIndices = [];
  Future<void> addAsset({
    required AssetEntity asset,
    required BuildContext context,
  }) async {
    if (selectedAsset.length == 10 && !selectedAsset.contains(asset)) {
      showSnackBarError(
        "Bạn chỉ có thể chọn tối đa là 10 ảnh hoặc video",
      );
    } else {
      selectedAsset.contains(asset)
          ? selectedAsset.remove(asset)
          : selectedAsset.add(asset);
      assetIndices =
          selectedAsset.map((asset) => selectedAsset.indexOf(asset)).toList();
    }
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
    selectedAsset.clear();
  }

  Future<bool> hasChangedSelectedAssets() async {
    final userUtils = ref.watch(userUtilsProvider);
    List<String>? assetIds = await userUtils.loadCacheList("selectedAsset");
    return assetIds?.length != selectedAsset.length;
  }
}
