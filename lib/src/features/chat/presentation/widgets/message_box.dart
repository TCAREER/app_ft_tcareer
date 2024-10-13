import 'package:app_tcareer/src/utils/app_utils.dart';
import 'package:flutter/material.dart';

Widget messageBox({
  required String message,
  bool isMe = false,
  required String createdAt,
}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.end,
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
            Container(
              margin: const EdgeInsets.only(bottom: 5),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                  color: isMe ? const Color(0xff1565C0) : Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: isMe
                          ? const Radius.circular(16)
                          : const Radius.circular(0),
                      bottomRight: !isMe
                          ? const Radius.circular(16)
                          : const Radius.circular(0))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message,
                    style: TextStyle(color: isMe ? Colors.white : Colors.black),
                  ),
                  Text(
                    AppUtils.formatCreatedAt(createdAt),
                    style: TextStyle(
                        color: isMe ? Colors.white : Colors.black54,
                        fontSize: 10),
                  )
                ],
              ),
            ),
          ],
        ),
      )
    ],
  );
}
