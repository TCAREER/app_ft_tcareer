import 'package:app_tcareer/src/configs/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

void showSnackBar(String message) {
  showSimpleNotification(
      Row(
        children: [
          PhosphorIcon(
            PhosphorIconsBold.checkCircle,
            color: Colors.green,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            message,
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
      background: Colors.white);
}

void showSnackBarError(String message) {
  showSimpleNotification(
      Row(
        children: [
          PhosphorIcon(
            PhosphorIconsBold.xCircle,
            color: Colors.red,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            message,
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
      background: Colors.white);
}
