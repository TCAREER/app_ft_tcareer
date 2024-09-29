import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget connectButton(
    {String? friendStatus, required void Function() onConnect}) {
  return Expanded(
    child: Column(
      children: [
        Visibility(
          visible: friendStatus != null,
          replacement: SizedBox(
            height: 35,
            width: ScreenUtil().screenWidth * .45,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                side: BorderSide(color: Colors.grey.shade100),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: onConnect,
              child: const Text("Đã gửi lời mời",
                  style: TextStyle(color: Colors.black)),
            ),
          ),
          child: SizedBox(
            height: 35,
            width: ScreenUtil().screenWidth * .45,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: onConnect,
              child: const Text("Thêm bạn bè",
                  style: TextStyle(color: Colors.white)),
            ),
          ),
        ),
      ],
    ),
  );
}
