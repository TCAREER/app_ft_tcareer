import 'package:app_tcareer/src/shared/widgets/shimmer_loading_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget cachedImageWidget(
    {String? imageUrl,
    double? height,
    double? width,
    Color? color,
    BoxFit? fit,
    BlendMode? colorBlendMode}) {
  return CachedNetworkImage(
      progressIndicatorBuilder: (context, url, progress) {
        return SizedBox(
          width: 20.0,
          height: 20.0,
          // child: CircularProgressIndicator(
          //   value: event == null ? 0 : event.cumulativeBytesLoaded / (event.expectedTotalBytes ?? 1),
          // ),
          child: CupertinoActivityIndicator(color: Colors.white, radius: 10),
        );
      },
      imageUrl: imageUrl ?? "",
      height: height,
      width: width,
      fit: fit,
      color: color, // Màu tối lại
      colorBlendMode: colorBlendMode,
      // placeholder: (context, url) {
      //   return shimmerLoadingWidget(
      //       child: Container(
      //     width: width,
      //     height: ScreenUtil().screenHeight * .2,
      //     color: Colors.white,
      //   ));
      // },
      errorWidget: (context, url, error) => imagePlaceholder());
}

Widget imagePlaceholder() {
  return Image.asset(
    "assets/images/posts/no_image.jpg",
    width: ScreenUtil().screenWidth,
    height: ScreenUtil().screenHeight * .2,
    fit: BoxFit.cover,
  );
}
