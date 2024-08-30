import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

Widget postWidget(
    {required BuildContext context,
    required String avatarUrl,
    required String userName,
    required String subName,
    required String createdAt,
    required String content,
    required String imageUrl,
    required String likes,
    required String comments,
    required String shares}) {
  return Container(
    color: Colors.white,
    padding: const EdgeInsets.all(4),
    width: MediaQuery.of(context).size.width,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(avatarUrl),
                ),
                const SizedBox(
                  width: 15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      subName,
                      style: const TextStyle(color: Colors.black54),
                    ),
                    Text(
                      createdAt,
                      style: const TextStyle(color: Colors.black54),
                    )
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Text(content),
            const SizedBox(
              height: 10,
            ),
            Image.network(
              imageUrl,
              fit: BoxFit.cover,
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                      text: TextSpan(children: [
                    WidgetSpan(
                        child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.blue),
                      child: const Icon(
                        Icons.thumb_up,
                        color: Colors.white,
                        size: 10,
                      ),
                    )),
                    TextSpan(
                        text: " $likes",
                        style: const TextStyle(
                            color: Colors.black54, fontSize: 12))
                  ])),
                  RichText(
                      text: TextSpan(
                          text: "$comments bình luận",
                          style: const TextStyle(
                              color: Colors.black54, fontSize: 12),
                          children: [
                        const WidgetSpan(
                            child: SizedBox(
                          width: 10,
                        )),
                        TextSpan(
                            text: " $shares lượt chia sẻ",
                            style: const TextStyle(color: Colors.black54))
                      ])),
                ],
              ),
            ),
            // Divider(
            //   height: 20,
            //   color: Colors.grey.shade300,
            // ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                      text: const TextSpan(children: [
                    WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: PhosphorIcon(
                          PhosphorIconsRegular.thumbsUp,
                          color: Colors.black54,
                          size: 20,
                        )),
                    TextSpan(
                        text: " Thích",
                        style: TextStyle(
                            color: Colors.grey,
                            // fontWeight: FontWeight.w600,
                            fontSize: 12))
                  ])),
                  RichText(
                      text: const TextSpan(children: [
                    WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: PhosphorIcon(
                          PhosphorIconsRegular.chatCircleDots,
                          color: Colors.black54,
                          size: 20,
                        )),
                    TextSpan(
                        text: " Bình luận",
                        style: TextStyle(
                            color: Colors.grey,
                            // fontWeight: FontWeight.w600,
                            fontSize: 12))
                  ])),
                  RichText(
                      text: const TextSpan(children: [
                    WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: PhosphorIcon(
                          PhosphorIconsRegular.messengerLogo,
                          color: Colors.black54,
                          size: 20,
                        )),
                    TextSpan(
                        text: " Gửi",
                        style: TextStyle(
                            color: Colors.grey,
                            // fontWeight: FontWeight.w600,
                            fontSize: 12))
                  ])),
                  RichText(
                      text: const TextSpan(children: [
                    WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: PhosphorIcon(
                          PhosphorIconsRegular.shareFat,
                          color: Colors.black54,
                          size: 20,
                        )),
                    TextSpan(
                        text: " Chia sẻ",
                        style: TextStyle(
                            color: Colors.grey,
                            // fontWeight: FontWeight.w600,
                            fontSize: 12))
                  ])),
                ],
              ),
            )
          ],
        )
      ],
    ),
  );
}
