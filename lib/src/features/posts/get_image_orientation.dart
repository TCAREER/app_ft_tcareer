import 'dart:async';
import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum ImageOrientation { portrait, landscape }

Future<ImageOrientation> getImageOrientation(dynamic imageSource) async {
  final Completer<ImageInfo> completer = Completer<ImageInfo>();
  Image image;

  if (imageSource is String) {
    // URL of the image
    image = Image.network(imageSource);
  } else if (imageSource is Uint8List) {
    // Uint8List of the image
    image = Image.memory(imageSource);
  } else if (imageSource is File) {
    // File of the image
    image = Image.file(imageSource);
  } else {
    throw ArgumentError('Unsupported image source');
  }

  image.image.resolve(ImageConfiguration()).addListener(
    ImageStreamListener(
      (ImageInfo imageInfo, bool synchronousCall) {
        completer.complete(imageInfo);
      },
    ),
  );

  final ImageInfo imageInfo = await completer.future;
  final int width = imageInfo.image.width;
  final int height = imageInfo.image.height;

  return width > height
      ? ImageOrientation.landscape
      : ImageOrientation.portrait;
}
