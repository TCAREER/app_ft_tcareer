import 'package:app_tcareer/src/configs/app_colors.dart';
import 'package:app_tcareer/src/shared/widgets/cached_image_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

Widget postImageWidget({required String imageUrl}) {
  return Stack(
    alignment: Alignment.bottomCenter,
    children: [
      CarouselSlider.builder(
          itemCount: 1,
          itemBuilder: (context, index, realIndex) {
            return cachedImageWidget(
                imageUrl: imageUrl,
                // height: ScreenUtil().screenHeight * .6,
                width: ScreenUtil().screenWidth,
                fit: BoxFit.cover);
          },
          options: CarouselOptions(
              enableInfiniteScroll: false, viewportFraction: 1)),
      const SizedBox(
        height: 10,
      ),
      // Center(
      //   child: AnimatedSmoothIndicator(
      //     count: 1,
      //     activeIndex: 0,
      //     effect: ScrollingDotsEffect(
      //         dotWidth: 5, dotHeight: 5, activeDotColor: AppColors.primary),
      //   ),
      // )
    ],
  );
}
