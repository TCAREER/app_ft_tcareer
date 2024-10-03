import 'dart:io';

import 'package:app_tcareer/src/features/index/index_controller.dart';
import 'package:app_tcareer/src/features/posts/presentation/posts_provider.dart';
import 'package:app_tcareer/src/features/posts/presentation/widgets/engagement_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PhotoViewGalleryPage extends ConsumerWidget {
  final List<String> images;
  final Function(int)? onPageChanged;
  final String postId;
  const PhotoViewGalleryPage(this.images, this.postId, this.onPageChanged,
      {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(postControllerProvider);

    Future.microtask(
      () {
        final initialIndex = controller.activeIndexMap[postId] ?? 0;
        print(">>>>>>>>>$initialIndex");
        controller.pageController.jumpToPage(initialIndex);
      },
    );
    return PopScope(
      onPopInvoked: (didPop) async {
        final indexController = ref.read(indexControllerProvider.notifier);
        indexController.setBottomNavigationBarVisibility(true);
      },
      child: Scaffold(
        appBar: AppBar(
          bottomOpacity: 0,
          elevation: 0.0,
          // toolbarOpacity: 0.5,
          backgroundColor: Colors.black,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.close,
              color: Colors.white,
            ),
            onPressed: () {
              final currentIndex = controller.activeIndexMap[postId] ?? 0;
              context.pop();
            },
          ),
          automaticallyImplyLeading: false,
          titleTextStyle: TextStyle(color: Colors.white),
          title: Visibility(
              visible: images.length > 1,
              child: Text(
                  "${(controller.activeIndexMap[postId] ?? 0) + 1}/${images.length}")),
        ),
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
                child: PhotoViewGallery.builder(
                    scrollPhysics: const BouncingScrollPhysics(),
                    builder: (BuildContext context, int index) {
                      final assetSource = images[index];
                      final isNetworkAsset = assetSource.isNetworkSource;
                      return PhotoViewGalleryPageOptions.customChild(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: PhotoView(
                            imageProvider: isNetworkAsset
                                ? CachedNetworkImageProvider(assetSource)
                                : FileImage(File(assetSource)),
                            minScale: PhotoViewComputedScale.contained,
                            initialScale: PhotoViewComputedScale.contained,
                            heroAttributes:
                                PhotoViewHeroAttributes(tag: assetSource),
                          ),
                        ),
                      );
                    },
                    itemCount: images.length,
                    loadingBuilder: (context, event) => const Center(
                          child: SizedBox(
                            width: 20.0,
                            height: 20.0,
                            child: CupertinoActivityIndicator(
                                color: Colors.white, radius: 10),
                          ),
                        ),
                    backgroundDecoration: const BoxDecoration(
                      color: Colors.black,
                    ),
                    pageController: controller.pageController,
                    onPageChanged: onPageChanged)),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
        // bottomNavigationBar: BottomAppBar(
        //   color: Colors.black,
        //   child: engagementWidget(
        //       index: 1,
        //       liked: true,
        //       ref: ref,
        //       postId: postId,
        //       context: context,
        //       likeCount: "0",
        //       shareCount: "0"),
        // ),
      ),
    );
  }
}

extension ImageSourcePath on String {
  bool get isNetworkSource => startsWith('http://') || startsWith('https://');
}
