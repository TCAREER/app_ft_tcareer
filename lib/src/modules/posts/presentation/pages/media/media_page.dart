import 'dart:typed_data';
import 'package:app_tcareer/src/modules/posts/presentation/posts_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:photo_manager/photo_manager.dart';

import 'show_album_pop_up.dart';

class MediaPage extends ConsumerWidget {
  const MediaPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(mediaControllerProvider);

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(
              Icons.close,
              color: Colors.black,
            ),
          ),
          title: GestureDetector(
            onTap: () async {
              if (controller.isShowPopUp != true) {
                await showAlbumPopup(context, controller.albums, ref);
              }
              controller.setIsShowPopUp(false);
            },
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 100),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(30)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(controller.selectedAlbum?.name ?? ""),
                    Visibility(
                        visible: controller.isShowPopUp != true,
                        replacement: const Icon(Icons.keyboard_arrow_up),
                        child: const Icon(Icons.keyboard_arrow_down))
                  ],
                ),
              ),
            ),
          ),
          actions: [
            Visibility(
              visible: controller.selectedAsset.isNotEmpty,
              replacement: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.camera_alt,
                    color: Colors.black,
                  )),
              child: TextButton(
                child: const Text(
                  "Hoàn tất",
                  style: TextStyle(color: Colors.blue),
                ),
                onPressed: () => controller.getImagePaths(context),
              ),
            )
          ],
        ),
        body: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
          ),
          itemCount: controller.media.length,
          itemBuilder: (context, index) {
            final item = controller.media[index];

            Uint8List? cachedThumbnail = controller.cachedThumbnails[item.id];

            return FutureBuilder<Uint8List?>(
              future: cachedThumbnail != null
                  ? Future.value(cachedThumbnail)
                  : item.thumbnailData,
              builder: (context, snapshot) {
                if (snapshot.hasData == false) {
                  return const Center();
                }

                if (cachedThumbnail == null && snapshot.data != null) {
                  controller.cachedThumbnails[item.id] = snapshot.data!;
                }

                bool isSelected = controller.selectedAsset.contains(item);
                int? selectedIndex = isSelected
                    ? controller.selectedAsset.indexOf(item) + 1
                    : null;

                return InkWell(
                  onTap: () async =>
                      await controller.addAsset(asset: item, context: context),
                  child: Container(
                    decoration: BoxDecoration(
                      border: isSelected
                          ? Border.all(color: Colors.blue, width: 2.5)
                          : null,
                    ),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.memory(
                            snapshot.data!,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            alignment: Alignment.center,
                            height: 24,
                            width: 24,
                            decoration: BoxDecoration(
                              border: isSelected
                                  ? Border.all(color: Colors.blue, width: 1)
                                  : Border.all(color: Colors.white, width: 1),
                              shape: BoxShape.circle,
                              color:
                                  isSelected ? Colors.blue : Colors.transparent,
                            ),
                            child: isSelected
                                ? Text(
                                    '$selectedIndex',
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 13),
                                    textAlign: TextAlign.center,
                                  )
                                : const Text(
                                    '2',
                                    style: const TextStyle(
                                        color: Colors.transparent,
                                        fontSize: 13),
                                    textAlign: TextAlign.center,
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ));
  }
}
