import 'package:app_tcareer/src/configs/app_colors.dart';
import 'package:flutter/material.dart';

@override
Widget circularLoadingWidget() {
  return const Center(
      child: CircularProgressIndicator(
    color: AppColors.primary,
  ));
}
