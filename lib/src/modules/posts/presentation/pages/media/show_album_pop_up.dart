import 'dart:typed_data';

import 'package:app_tcareer/src/modules/posts/presentation/posts_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_manager/photo_manager.dart';

Future<AssetPathEntity?> showAlbumPopup(
    BuildContext context, List<AssetPathEntity> albums, WidgetRef ref) async {
  final controller = ref.watch(mediaControllerProvider);

  if (albums.isEmpty) {
    return Future.value(null);
  }

  final List<Map<String, dynamic>> albumWithThumbnail = [];

  for (var album in albums) {
    final List<AssetEntity> assets =
        await album.getAssetListPaged(page: 1, size: 1);
    final AssetEntity? assetFirst = assets.isNotEmpty ? assets.first : null;
    int totalAssets = await album.assetCountAsync;
    albumWithThumbnail
        .add({"album": album, "first": assetFirst, "total": totalAssets});
  }
  return showMenu<AssetPathEntity>(
    color: Colors.white,
    // ignore: use_build_context_synchronously
    context: context,
    constraints: BoxConstraints(minWidth: ScreenUtil().screenWidth),
    position: const RelativeRect.fromLTRB(100, 80, 100, 100),
    items: albumWithThumbnail.map((albumData) {
      final AssetPathEntity album = albumData["album"];
      final AssetEntity assetFirst = albumData["first"];
      controller.setIsShowPopUp(true);
      return PopupMenuItem<AssetPathEntity>(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        onTap: () async => await controller.selectAlbum(album),
        value: album,
        child: ListTile(
          leading: FutureBuilder<Uint8List?>(
            future: assetFirst.thumbnailData,
            builder: (context, snapshot) {
              if (snapshot.hasData == false) {
                return Center();
              }
              return Image.memory(
                snapshot.data!,
                height: 64,
                width: 64,
                fit: BoxFit.cover,
              );
            },
          ),
          title: Text(album.name),
          subtitle: Text("${albumData["total"]}"),
        ),
      );
    }).toList(),
  );
}
