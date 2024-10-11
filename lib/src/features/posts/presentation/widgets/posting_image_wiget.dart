import 'dart:io';
import 'package:app_tcareer/src/extensions/image_extension.dart';
import 'package:app_tcareer/src/features/posts/get_image_orientation.dart';
import 'package:app_tcareer/src/features/posts/presentation/posts_provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Sử dụng provider có sẵn để lấy hướng ảnh
Widget postingImageWidget(
    {required List<String> mediaUrl, required WidgetRef ref}) {
  final controller = ref.watch(postingControllerProvider);

  // Kiểm tra mediaUrl không rỗng trước khi truy cập phần tử đầu tiên
  if (mediaUrl.isEmpty) {
    return const SizedBox(); // Trả về một widget trống nếu mediaUrl rỗng
  }

  // Dùng hàm getImageOrientation cho cả file và network để xác định hướng ảnh
  return FutureBuilder<ImageOrientation>(
    future: getImageOrientation(mediaUrl.first),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return _buildCarousel(mediaUrl, ref, aspectRatio: 16 / 9);
      } else if (snapshot.hasError) {
        return _buildCarousel(mediaUrl, ref, aspectRatio: 16 / 9);
      } else if (snapshot.hasData) {
        final orientation = snapshot.data;
        final aspectRatio =
            orientation == ImageOrientation.landscape ? 1.91 : 4 / 5;
        return _buildCarousel(mediaUrl, ref, aspectRatio: aspectRatio);
      } else {
        return const SizedBox(); // Trả về widget trống trong trường hợp lỗi
      }
    },
  );
}

Widget _buildCarousel(List<String> images, WidgetRef ref,
    {double aspectRatio = 1.91}) {
  final controller = ref.watch(postingControllerProvider);
  final mediaController = ref.watch(mediaControllerProvider);

  return Column(
    children: [
      CarouselSlider.builder(
        itemCount: images.length,
        itemBuilder: (context, index, realIndex) {
          String image = images[index];
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: image.isImageNetWork
                      ? Image.network(
                          image,
                          width: ScreenUtil().screenWidth,
                          fit: BoxFit.cover,
                        )
                      : Image.file(
                          File(image),
                          width: ScreenUtil().screenWidth,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              Positioned(
                right: 15,
                top: 5,
                child: GestureDetector(
                  onTap: () {
                    mediaController.removeImage(index);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
        options: CarouselOptions(
          enableInfiniteScroll: false,
          viewportFraction: 1,
          aspectRatio: aspectRatio,
          onPageChanged: (index, reason) => controller.setActiveIndex(index),
        ),
      ),
      const SizedBox(height: 10),
      Center(
        child: AnimatedSmoothIndicator(
          count: images.length,
          activeIndex: controller.activeIndex,
          effect: const ScrollingDotsEffect(
            dotWidth: 5,
            dotHeight: 5,
            activeDotColor: Colors.blue,
          ),
        ),
      ),
    ],
  );
}
