import 'package:flutter/material.dart';

Widget commentItemWidget() {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        flex: 1,
        child: Column(
          children: [
            CircleAvatar(
              radius: 15,
              backgroundImage: NetworkImage(
                  "https://mighty.tools/mockmind-api/content/human/39.jpg"),
            ),
          ],
        ),
      ),
      Expanded(
        flex: 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                  text: 'Quang Thiện ',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                        text: '1 giờ',
                        style: TextStyle(fontSize: 12, color: Colors.black54))
                  ]),
            ),
            const Text(
              "Tokio I have filmed a small vlog of north Dhaka🤭",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              "Trả lời",
              style: TextStyle(color: Colors.black54, fontSize: 12),
            )
          ],
        ),
      ),
      Expanded(
        flex: 1,
        child: Column(
          children: [
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.favorite_outline,
                  size: 20,
                  color: Colors.grey,
                ))
          ],
        ),
      ),
    ],
  );
}
