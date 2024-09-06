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
  return Visibility(
    visible: imageUrl != "" && imageUrl != null,
    replacement: Container(
      width: width,
      height: ScreenUtil().screenHeight * .4,
      color: Colors.white,
      child: const Icon(
        Icons.image,
        size: 30,
      ),
    ),
    child: CachedNetworkImage(
        imageUrl: imageUrl ?? "",
        height: height,
        width: width,
        fit: fit,
        color: color, // Màu tối lại
        colorBlendMode: colorBlendMode,
        placeholder: (context, url) {
          return shimmerLoadingWidget(
              child: Container(
            width: width,
            height: ScreenUtil().screenHeight * .2,
            color: Colors.white,
          ));
        },
        errorWidget: (context, url, error) {
          return Container(
            width: width,
            height: ScreenUtil().screenHeight * .4,
            color: Colors.white,
            child: const Icon(
              Icons.image,
              size: 30,
            ),
          );
        }),
  );
}
