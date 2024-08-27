import 'package:app_tcareer/src/shared/configs/app_colors.dart';
import 'package:flutter/material.dart';

Widget authButtonWidget(
    {required BuildContext context,
    required,
    required void Function()? onPressed,
    required String title}) {
  return SizedBox(
    height: 50,
    width: MediaQuery.of(context).size.width,
    child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            backgroundColor: AppColors.authButton),
        onPressed: onPressed,
        child: Text(
          title,
          style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.84),
        )),
  );
}
