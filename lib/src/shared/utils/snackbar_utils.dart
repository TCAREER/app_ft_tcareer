import 'package:app_tcareer/src/configs/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

void showSnackBar(String message) {
  showSimpleNotification(Text(message), background: AppColors.primary);
}

void showSnackBarError(String message) {
  showSimpleNotification(Text(message), background: Colors.grey.shade300);
}
