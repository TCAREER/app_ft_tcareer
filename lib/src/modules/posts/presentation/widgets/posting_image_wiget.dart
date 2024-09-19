import 'dart:io';

import 'package:app_tcareer/src/configs/app_colors.dart';
import 'package:app_tcareer/src/modules/posts/get_image_orientation.dart';
import 'package:app_tcareer/src/modules/posts/presentation/posts_provider.dart';
import 'package:app_tcareer/src/shared/widgets/cached_image_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

Widget postingImageWidget({List<String>? mediaUrl, required WidgetRef ref}) {
  final controller = ref.watch(postingControllerProvider);
  return Column(
    children: [
      Visibility(
        visible: controller.imagesWeb?.isNotEmpty == true,
        replacement: CarouselSlider.builder(
            itemCount: mediaUrl?.length,
            itemBuilder: (context, index, realIndex) {
              final image = mediaUrl?[index];
              return Image.file(File(image!),
                  width: ScreenUtil().screenWidth, fit: BoxFit.cover);
            },
            options: CarouselOptions(
              enableInfiniteScroll: false,
              viewportFraction: 1,
              onPageChanged: (index, reason) =>
                  controller.setActiveIndex(index),
            )),
        child: CarouselSlider.builder(
            itemCount: controller.imagesWeb?.length,
            itemBuilder: (context, index, realIndex) {
              final image = controller.imagesWeb?[index];
              return Image.memory(image!,
                  width: ScreenUtil().screenWidth, fit: BoxFit.cover);
            },
            options: CarouselOptions(
              aspectRatio: mediaUrl?.isNotEmpty == true ||
                      controller.imagesWeb?.isNotEmpty == true
                  ? ref
                      .watch(imageOrientationProvider(
                          controller.imagesWeb?.isNotEmpty != true
                              ? File(mediaUrl?.first ?? "")
                              : controller.imagesWeb?[0]))
                      .when(
                      data: (orientation) {
                        print(
                            'Orientation: $orientation'); // Debug: in ra hướng
                        return orientation == ImageOrientation.landscape
                            ? 1.91 // Tỉ lệ cho ảnh ngang
                            : 4 / 5; // Tỉ lệ cho ảnh dọc
                      },
                      loading: () {
                        print('Loading...'); // Debug: in ra trạng thái đang tải
                        return 16 / 9; // Giá trị mặc định khi chưa tải xong
                      },
                      error: (error, stack) {
                        print('Error: $error'); // Debug: in ra lỗi
                        return 16 / 9; // Giá trị mặc định khi có lỗi
                      },
                    )
                  : 1,
              enableInfiniteScroll: false,
              viewportFraction: 1,
              onPageChanged: (index, reason) =>
                  controller.setActiveIndex(index),
            )),
      ),
      const SizedBox(
        height: 10,
      ),
      Visibility(
        visible: mediaUrl != null || controller.imagesWeb?.isNotEmpty == true,
        child: Center(
          child: Visibility(
            visible: controller.imagesWeb?.isNotEmpty == true,
            replacement: AnimatedSmoothIndicator(
              count: mediaUrl?.length ?? 0,
              activeIndex: controller.activeIndex,
              effect: const ScrollingDotsEffect(
                  dotWidth: 5, dotHeight: 5, activeDotColor: Colors.blue),
            ),
            child: AnimatedSmoothIndicator(
              count: controller.imagesWeb?.length ?? 0,
              activeIndex: controller.activeIndex,
              effect: const ScrollingDotsEffect(
                  dotWidth: 5, dotHeight: 5, activeDotColor: Colors.blue),
            ),
          ),
        ),
      )
    ],
  );
}
