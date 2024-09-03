import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
      // width: width,
      // height: height,
      color: Colors.grey.shade200,
      child: Icon(
        Icons.image,
        size: 100,
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
          return Container(
            width: width,
            height: height,
            color: Colors.grey.shade200,
            child: const Icon(
              Icons.image,
              size: 100,
            ),
          );
        },
        errorWidget: (context, url, error) {
          return const Icon(
            Icons.image,
            size: 100,
          );
        }),
  );
}
