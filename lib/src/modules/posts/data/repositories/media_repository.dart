import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    size = (totalAssets ?? 0) > 10 ? size : totalAssets;
    List<AssetEntity>? assets =
        await album.getAssetListPaged(page: page, size: size ?? totalAssets);

    return assets;
  }
}

final mediaRepository = Provider((ref) => MediaRepository());
