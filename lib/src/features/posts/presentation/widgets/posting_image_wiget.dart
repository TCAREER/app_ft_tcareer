import 'dart:io';
import 'dart:typed_data';
import 'package:app_tcareer/src/features/posts/presentation/posts_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:app_tcareer/src/extensions/image_extension.dart';

Widget postingImageWidget({List<String>? mediaUrl, required WidgetRef ref}) {
  // final controller = ref.watch(postingControllerProvider);
  return _buildCarousel(mediaUrl!, ref);
  // return Column(
  //   children: [
  //     // FutureBuilder<Size?>(
  //     //   future: mediaUrl != null && mediaUrl.isNotEmpty
  //     //       ? _getFileImageSize(File(mediaUrl.first))
  //     //       : Future.value(null),
  //     //   builder: (context, snapshot) {
  //     //     double aspectRatio = 1.91; // Giá trị mặc định
  //     //
  //     //     if (snapshot.hasData && snapshot.data != null) {
  //     //       final size = snapshot.data!;
  //     //       aspectRatio = size.width > size.height ? 1.91 : 4 / 5;
  //     //     }
  //     //
  //     //
  //     //   },
  //     // ),
  //   ],
  // );
}

Widget _buildCarousel(List<dynamic> images, WidgetRef ref) {
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
                    // Gọi hàm để xóa ảnh tại index
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
          // aspectRatio: aspectRatio,
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

// Hàm tính kích thước ảnh từ File
Future<Size> _getFileImageSize(File imageFile) async {
  final image = await decodeImageFromList(imageFile.readAsBytesSync());
  return Size(image.width.toDouble(), image.height.toDouble());
}

// Hàm tính kích thước ảnh từ Uint8List (imageWeb)
Future<Size> _getImageSize(Uint8List imageBytes) async {
  final image = await decodeImageFromList(imageBytes);
  return Size(image.width.toDouble(), image.height.toDouble());
}
