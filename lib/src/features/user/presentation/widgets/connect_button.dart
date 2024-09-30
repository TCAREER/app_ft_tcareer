import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget connectButton(
    {required String friendStatus,
    void Function()? onConnect,
    void Function()? onDecline,
    void Function()? onAccept}) {
  Map<String, dynamic> friendStatusMap = {
    "is_friend": "Bạn bè",
    "sent_request": "Hủy yêu cầu",
    "received_request": "Đồng ý kết bạn",
    "default": "Thêm bạn bè"
  };
  Map<String, dynamic> connectCallBack = {
    "is_friend": onDecline,
    "sent_request": () {},
    "received_request": onAccept,
    "default": onConnect
  };
  return Expanded(
    child: SizedBox(
      height: 35,
      child: Visibility(
        visible: friendStatus != "is_friend",
        replacement: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            side: BorderSide(color: Colors.grey.shade200, width: 1.2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: onConnect,
          child: Text(friendStatusMap[friendStatus],
              style: const TextStyle(color: Colors.black)),
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: connectCallBack[friendStatus],
          child: Text(friendStatusMap[friendStatus],
              style: const TextStyle(color: Colors.white)),
        ),
      ),
    ),
  );
}
