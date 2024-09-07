import 'package:app_tcareer/src/shared/widgets/cached_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'engagement_widget.dart';
import 'post_image_widget.dart';

Widget postWidget({
  required BuildContext context,
  required WidgetRef ref,
  required String avatarUrl,
  required String userName,
  required String subName,
  required String createdAt,
  required String content,
  required String imageUrl,
  required String likes,
  required String comments,
  required String shares,
  required String postId,
}) {
  return Container(
    color: Colors.white,
    // padding: const EdgeInsets.all(4),
    width: ScreenUtil().screenWidth,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            height: 25,
                            child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    backgroundColor: Colors.blueGrey.shade50),
                                child: const Text(
                                  "Theo dõi",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 12),
                                )),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const PhosphorIcon(PhosphorIconsBold.dotsThree),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(content),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            postImageWidget(imageUrl: imageUrl),
            const SizedBox(
              height: 10,
            ),
            engagementWidget(ref, postId, context),
            const SizedBox(
              height: 10,
            ),
          ],
        )
      ],
    ),
  );
}
