import 'package:app_tcareer/src/shared/configs/exceptions/api_exception.dart';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
}
