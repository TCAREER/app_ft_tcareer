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
        child: CircleAvatar(
          radius: 15,
          backgroundImage: NetworkImage(
              "https://mighty.tools/mockmind-api/content/human/41.jpg"),
        ),
      ),
      const SizedBox(
        width: 10,
      ),
      Container(
        margin: EdgeInsets.only(bottom: 5),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: isMe ? Color(0xff1565C0) : Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomLeft: isMe ? Radius.circular(16) : Radius.circular(0),
                bottomRight: !isMe ? Radius.circular(16) : Radius.circular(0))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style: TextStyle(color: isMe ? Colors.white : Colors.black),
            ),
            Text(
              createdAt,
              style: TextStyle(
                  color: isMe ? Colors.white : Colors.black54, fontSize: 10),
            )
          ],
        ),
      )
    ],
  );
}
