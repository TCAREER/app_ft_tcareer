import 'dart:typed_data';

import 'package:app_tcareer/src/modules/posts/presentation/posts_provider.dart';
import 'package:app_tcareer/src/shared/widgets/circular_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:photo_manager/photo_manager.dart';

class MediaPage extends ConsumerWidget {
  const MediaPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(mediaControllerProvider);
    final controller = ref.read(mediaControllerProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        // leading: GestureDetector(
        //   onTap: () => context.pop(),
        //   child: const Text("Quay lại"),
        // ),
        title: GestureDetector(
          onTap: () async {
            // Hiển thị popup khi nhấn vào tiêu đề
            await controller.getAlbums();
            await showAlbumPopup(context, state.albums);
          },
          child: Container(
            color: Colors.grey,
            child: Row(
              children: [
                Text(state.albums?.first.name ?? ""),
                const Icon(Icons.arrow_drop_down)
              ],
            ),
          ),
        ),
      ),
      body: state.isLoading
          ? circularLoadingWidget()
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: state.media?.length,
              itemBuilder: (context, index) {
                final item = state.media?[index];
                return FutureBuilder<Uint8List?>(
                  future: item?.thumbnailData, // Lấy thumbnail của ảnh/video
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.data != null) {
                      return Stack(
                        children: [
                          // Hiển thị thumbnail
                          Positioned.fill(
                            child: Image.memory(
                              snapshot.data!,
                              fit: BoxFit.cover,
                            ),
                          ),
                          // Nếu là video, hiển thị thời gian và nút Play
                          if (item?.type == AssetType.video) ...[
                            // Thời gian video
                            Positioned(
                              bottom: 5,
                              left: 5,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                color: Colors.black54,
                                child: Text(
                                  _formatDuration(item!.videoDuration),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                            // Nút Play
                            const Positioned(
                              top: 0,
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Icon(
                                Icons.play_circle_outline,
                                color: Colors.white,
                                size: 48,
                              ),
                            ),
                          ],
                        ],
                      );
                    } else {
                      return const Center();
                    }
                  },
                );
              },
            ),
    );
  }

  Future<AssetPathEntity?> showAlbumPopup(
      BuildContext context, List<AssetPathEntity>? albums) {
    // if (albums == null || albums.isEmpty) {
    //   return Future.value(null); // Không có album nào để hiển thị
    // }
    return showMenu<AssetPathEntity>(
      context: context,
      position: const RelativeRect.fromLTRB(100, 80, 100, 100),
      items: albums?.map((album) {
            return PopupMenuItem<AssetPathEntity>(
              value: album,
              child: Text(album.name),
            );
          }).toList() ??
          [],
    );
  }

  String _formatDuration(Duration duration) {
    return DateFormat('mm:ss').format(DateTime(0).add(duration));
  }
}
