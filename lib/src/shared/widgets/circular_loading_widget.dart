import 'package:app_tcareer/src/configs/app_colors.dart';
import 'package:flutter/material.dart';

@override
Widget circularLoadingWidget(BuildContext context) {
  return Center(
      child: CircularProgressIndicator(
    color: AppColors.primary,
  ));
}
