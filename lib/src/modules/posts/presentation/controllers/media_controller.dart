import 'dart:io';
import 'dart:typed_data';

import 'package:app_tcareer/src/modules/posts/data/models/media_state.dart';
import 'package:app_tcareer/src/modules/posts/usecases/media_use_case.dart';
import 'package:app_tcareer/src/shared/utils/snackbar_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_manager/photo_manager.dart';

class MediaController extends ChangeNotifier {
  final MediaUseCase mediaUseCase;
  MediaController(this.mediaUseCase);

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

  List<AssetEntity> selectedAsset = [];

  Future<void> addAsset({
    required AssetEntity asset,
    required BuildContext context,
  }) async {
    if (selectedAsset.length > 9 && !selectedAsset.contains(asset)) {
      showSnackBarError(
        context: context,
        message: "Bạn chỉ có thể chọn tối đa là 10 ảnh hoặc video",
      );
      return; // Không tiếp tục xử lý nếu số lượng đã vượt quá giới hạn
    }

    // Thêm hoặc loại bỏ asset
    selectedAsset.contains(asset)
        ? selectedAsset.remove(asset)
        : selectedAsset.add(asset);

    print(">>>>>>>>>>>${selectedAsset.length}");
    notifyListeners();
  }

  List<int> get assentIndices {
    return selectedAsset.map((asset) => selectedAsset.indexOf(asset)).toList();
  }

  Map<String, Uint8List?> cachedThumbnails = {};

  bool isShowPopUp = false;

  void setIsShowPopUp(bool value) {
    isShowPopUp = value;
    notifyListeners();
  }

  void clearData() {
    selectedAsset.clear();
  }

  List<String> imagePaths = [];
  Future<void> getImagePaths(BuildContext context) async {
    imagePaths.clear();
    for (AssetEntity asset in selectedAsset) {
      File? file = await asset.file;
      if (file != null) {
        imagePaths.add(file.path);
        notifyListeners();
      }
    }
    context.pop();
  }
}
