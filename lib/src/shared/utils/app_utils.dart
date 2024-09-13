import 'dart:io';
import 'dart:typed_data';

import 'package:app_tcareer/src/configs/exceptions/api_exception.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:heif_converter/heif_converter.dart';
import 'package:image/image.dart' as img;
import 'alert_dialog_util.dart';

class AppUtils {
  static showLoading(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  static Future<void> loadingApi(
      Function onLoading, BuildContext context) async {
    AlertDialogUtil alertDialog = AlertDialogUtil();
    try {
      showDialog(
        context: context,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );
      await onLoading();
      context.pop();
    } on DioException catch (error) {
      context.pop();
      if (error.response?.statusCode != null) {
        if (error.response?.statusCode == 400) {
          showExceptionErrorUser(error, context);
        } else {
          checkExceptionStatusCode(error, context);
        }
      } else {
        checkException(error, context);
      }
    }
    // catch (e) {
    //   context.pop();
    //   alertDialog.showAlert(
    //       context: context, title: "Có lỗi xảy ra", content: e.toString());
    // }
  }

  static Future<void> futureApi(Function onLoading, BuildContext context,
      void Function(bool value) setIsLoading) async {
    try {
      setIsLoading(true);
      await onLoading();
    } on DioException catch (error) {
      setIsLoading(false);
      if (error.response?.statusCode != null) {
        if (error.response?.statusCode == 400) {
          showExceptionErrorUser(error, context);
        } else {
          checkExceptionStatusCode(error, context);
        }
      } else {
        checkException(error, context);
      }
    }
  }

  static void checkException(DioException error, BuildContext context) {
    ApiException exception = ApiException();
    List<String> errorMessage = exception.getExceptionMessage(error);
    AlertDialogUtil.showAlert(
        context: context, title: errorMessage[0], content: errorMessage[1]);
  }

  static void checkExceptionStatusCode(
      DioException error, BuildContext context) {
    ApiException exception = ApiException();

    List<String> errorMessage =
        exception.getHttpStatusMessage(error.response?.statusCode ?? 0);
    AlertDialogUtil.showAlert(
        context: context, title: errorMessage[0], content: errorMessage[1]);
  }

  static void showExceptionErrorUser(DioException error, BuildContext context) {
    if (error.response?.data != null) {
      final errorData = error.response?.data;
      final err = errorData['error'];
      if (err != null) {
        final errorObject = err['errors'];
        if (errorObject != null) {
          final errorMessage = errorObject['msg'];
          if (errorMessage != null) {
            AlertDialogUtil.showAlert(
                context: context,
                title: "Có lỗi xảy ra",
                content: errorMessage);
          }
        }
      }
    }
  }

  static Future<String?> compressImage(String filePath) async {
    String? path;
    if (await isHeif(filePath) == true) {
      filePath = await HeifConverter.convert(filePath, output: filePath) ?? "";
    }
    File file = File(filePath);
    // print(">>>>>>filePath: $filePath");
    List<int> imageBytes = await file.readAsBytes();
    // print(">>>>>>>imageBytes: $imageBytes");
    img.Image? image = img.decodeImage(Uint8List.fromList(imageBytes));
    // print(">>>>>>>>>>image: $image");
    if (image != null) {
      Uint8List jpgBytes =
          Uint8List.fromList(img.encodeJpg(image, quality: 70));
      String fileNameWithoutExtension =
          filePath.substring(0, filePath.lastIndexOf('.'));
      File newFile = File('$fileNameWithoutExtension.jpg');
      newFile = await newFile.writeAsBytes(jpgBytes);
      path = newFile.path;
      // print(">>>>>>>>>>path: $path");
    }
    return path;
  }

  static Future<bool> isHeif(String filePath) async {
    File file = File(filePath);
    Uint8List bytes = await file.readAsBytes();

    // HEIF files start with 'ftyp' at byte 4-7.
    if (bytes.length >= 12 &&
        bytes[4] == 0x66 &&
        bytes[5] == 0x74 &&
        bytes[6] == 0x79 &&
        bytes[7] == 0x70) {
      // Check for specific HEIF major brand identifiers
      String majorBrand = String.fromCharCodes(bytes.sublist(8, 12));
      if (majorBrand == 'heic' ||
          majorBrand == 'heix' ||
          majorBrand == 'hevc') {
        return true;
      }
    }

    return false;
  }
}
