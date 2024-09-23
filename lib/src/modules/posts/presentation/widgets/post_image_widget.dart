import 'dart:async';
import 'package:app_tcareer/src/configs/app_colors.dart';
import 'package:app_tcareer/src/modules/index/index_controller.dart';
import 'package:app_tcareer/src/modules/posts/data/models/photo_view_data.dart';
import 'package:app_tcareer/src/modules/posts/get_image_orientation.dart';
import 'package:app_tcareer/src/modules/posts/presentation/posts_provider.dart';
import 'package:app_tcareer/src/shared/widgets/cached_image_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

// Import provider cho imageOrientationProvider
class PostImageWidget extends ConsumerStatefulWidget {
  final List<String> mediaUrl;
  final String postId;

  PostImageWidget({required this.mediaUrl, required this.postId});

  @override
  _PostImageWidgetState createState() => _PostImageWidgetState();
}

class _PostImageWidgetState extends ConsumerState<PostImageWidget> {
  late CarouselController carouselController;

  @override
  void initState() {
    super.initState();
    carouselController = CarouselController();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(postControllerProvider);

    return Column(
      children: [
        CarouselSlider.builder(
          carouselController: carouselController,
          itemCount: widget.mediaUrl.length,
          itemBuilder: (context, index, realIndex) {
            final image = widget.mediaUrl[index];

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: GestureDetector(
                  onTap: () {
                    final indexController =
                        ref.read(indexControllerProvider.notifier);
                    indexController.setBottomNavigationBarVisibility(false);
                    final data = PhotoViewData(
                        images: widget.mediaUrl,
                        index: index,
                        onPageChanged: (index) {
                          controller.setActiveIndex(
                              index: index, postId: widget.postId);
                          Future.microtask(() {
                            final index =
                                controller.getActiveIndex(widget.postId);
                            carouselController.animateToPage(
                              index,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          });
                        });
                    context.goNamed("photoView",
                        queryParameters: {"postId": widget.postId},
                        extra: data);
                  },
                  child: Hero(
                    tag: image,
                    child: cachedImageWidget(
                      imageUrl: image,
                      width: ScreenUtil().screenWidth,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            );
          },
          options: CarouselOptions(
            aspectRatio: ref
                .watch(imageOrientationProvider(widget.mediaUrl[0]))
                .when(
                  data: (orientation) =>
                      orientation == ImageOrientation.landscape ? 1.91 : 4 / 5,
                  loading: () => 16 / 9, // Giá trị mặc định khi chưa tải xong
                  error: (error, stack) =>
                      16 / 9, // Giá trị mặc định khi có lỗi
                ),
            initialPage: controller.getActiveIndex(widget.postId),
            enableInfiniteScroll: false,
            viewportFraction: 1,
            onPageChanged: (index, reason) =>
                controller.setActiveIndex(index: index, postId: widget.postId),
          ),
        ),
        const SizedBox(height: 10),
        Visibility(
          visible: widget.mediaUrl.length > 1,
          child: Center(
            child: AnimatedSmoothIndicator(
              count: widget.mediaUrl.length,
              activeIndex: controller.getActiveIndex(widget.postId),
              effect: ScrollingDotsEffect(
                dotWidth: 5,
                dotHeight: 5,
                activeDotColor: Colors.blue,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
