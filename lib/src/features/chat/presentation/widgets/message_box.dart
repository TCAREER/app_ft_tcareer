import 'package:app_tcareer/src/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget messageBox({
  required String message,
  bool isMe = false,
  required String createdAt,
}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: !isMe ? MainAxisAlignment.start : MainAxisAlignment.end,
    children: [
      Visibility(
        visible: !isMe,
        child: const CircleAvatar(
          radius: 15,
          backgroundImage: NetworkImage(
              "https://mighty.tools/mockmind-api/content/human/41.jpg"),
        ),
      ),
      const SizedBox(
        width: 10,
      ),
      Flexible(
        child: Column(
          children: [
            ConstrainedBox(
              constraints:
                  BoxConstraints(maxWidth: ScreenUtil().screenWidth * .7),
              child: Container(
                margin: const EdgeInsets.only(bottom: 5),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                    color: isMe ? const Color(0xff3E66FB) : Colors.white,
                    borderRadius: BorderRadius.circular(16)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message,
                      style: TextStyle(
                          color: isMe ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      AppUtils.formatCreatedAt(createdAt),
                      style: TextStyle(
                          color: isMe ? Colors.white : Colors.black54,
                          fontSize: 11,
                          fontWeight: FontWeight.w300),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
