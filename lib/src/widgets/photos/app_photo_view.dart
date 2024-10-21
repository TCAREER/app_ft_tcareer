import 'dart:io';
import 'package:app_tcareer/src/features/index/index_controller.dart';
import 'package:app_tcareer/src/features/posts/presentation/posts_provider.dart';
import 'package:app_tcareer/src/features/posts/presentation/widgets/engagement_widget.dart';
import 'package:app_tcareer/src/widgets/photos/app_photo_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class AppPhotoView extends StatefulWidget {
  final AppPhotoModel data;

  const AppPhotoView({super.key, required this.data});

  @override
  State<AppPhotoView> createState() => _AppPhotoViewState();
}

class _AppPhotoViewState extends State<AppPhotoView> {
  PageController pageController = PageController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      pageController.jumpToPage(widget.data.index);
    });
  }

  int index = 0;
  void setIndex(int value) {
    setState(() {
      index = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) async {},
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
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
              onPressed: () => context.pop(),
            ),
            automaticallyImplyLeading: false,
            titleTextStyle: TextStyle(color: Colors.white),
            title: Visibility(
                visible: widget.data.images.length > 1,
                child: Text("${index + 1}/${widget.data.images.length}")),
          ),
          body: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              PhotoViewGallery.builder(
                  pageController: pageController,
                  scrollPhysics: const BouncingScrollPhysics(),
                  builder: (BuildContext context, int index) {
                    final assetSource = widget.data.images[index];
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
                  itemCount: widget.data.images.length,
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
                  // pageController: controller.pageController,
                  onPageChanged: (val) {
                    setIndex(val);
                    widget.data.onPageChanged!(val);
                  }),
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
      ),
    );
  }
}

extension ImageSourcePath on String {
  bool get isNetworkSource => startsWith('http://') || startsWith('https://');
}
