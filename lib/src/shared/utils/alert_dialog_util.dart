import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AlertDialogUtil {
  static AlertDialog alertDialog(
      {required BuildContext context,
      required String title,
      required String content}) {
    return AlertDialog(
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      // icon: Icon(
      //   Icons.error,
      //   color: Colors.red,
      //   size: 40,
      // ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () => context.pop(),
          child: Text(
            "Thoát",
            style: TextStyle(color: Colors.red),
          ),
        )
      ],
    );
  }

  static void showAlert(
      {required BuildContext context,
      required String title,
      required String content}) {
    showDialog(
      context: context,
      builder: (context) =>
          alertDialog(context: context, title: title, content: content),
    );
  }
}
