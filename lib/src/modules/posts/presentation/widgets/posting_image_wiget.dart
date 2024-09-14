import 'dart:io';

import 'package:app_tcareer/src/configs/app_colors.dart';
import 'package:app_tcareer/src/modules/posts/presentation/posts_provider.dart';
import 'package:app_tcareer/src/shared/widgets/cached_image_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

Widget postingImageWidget(
    {required List<String> mediaUrl, required WidgetRef ref}) {
  final controller = ref.watch(postingControllerProvider);
  return Column(
    children: [
      Visibility(
        visible: controller.imagesWeb?.isNotEmpty == true,
        replacement: CarouselSlider.builder(
            itemCount: mediaUrl.length,
            itemBuilder: (context, index, realIndex) {
              final image = mediaUrl[index];
              return Image.file(File(image),
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
              enableInfiniteScroll: false,
              viewportFraction: 1,
              onPageChanged: (index, reason) =>
                  controller.setActiveIndex(index),
            )),
      ),
      const SizedBox(
        height: 10,
      ),
      Center(
        child: Visibility(
          visible: controller.imagesWeb?.isNotEmpty == true,
          replacement: AnimatedSmoothIndicator(
            count: mediaUrl.length,
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
      )
    ],
  );
}
