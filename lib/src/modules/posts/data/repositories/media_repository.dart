import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';

class MediaRepository {
  Future<bool> requestPermission() async {
    final PermissionState result = await PhotoManager.requestPermissionExtend();
    if (result.isAuth) {
      return true;
    }
    PhotoManager.openSetting();
    return false;
  }

  Future<List<AssetPathEntity>> getAlbums() async {
    return await PhotoManager.getAssetPathList(
        type: RequestType.image | RequestType.video);
  }

  Future<List<AssetEntity>> getMediaFromAlbum(
      {required AssetPathEntity album, int page = 0, int? size}) async {
    int? totalAssets = await album.assetCountAsync;
    size = totalAssets > 10 ? size : totalAssets;
    List<AssetEntity>? assets =
        await album.getAssetListPaged(page: page, size: size ?? totalAssets);

    return assets;
  }

  Future<List<Uint8List>?> pickImageWeb() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();
    List<Uint8List> images = [];
    //  if (pickedFiles == null) return null;
    for (var file in pickedFiles) {
      final bytes = await file.readAsBytes();
      images.add(bytes);
    }
    return images;
  }

  Future<Uint8List?> pickVideoWeb() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickVideo(source: ImageSource.gallery);
    Uint8List? video = await pickedFiles?.readAsBytes();
    return video;
  }
}

final mediaRepository = Provider((ref) => MediaRepository());
