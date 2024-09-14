import 'package:app_tcareer/src/shared/widgets/cached_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_fb_photo_view/flutter_fb_photo_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:readmore/readmore.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'engagement_widget.dart';
import 'post_image_widget.dart';

Widget postWidget(
    {required BuildContext context,
    required WidgetRef ref,
    required String avatarUrl,
    required String userName,
    String? subName,
    required String createdAt,
    required String content,
    required List<String> images,
    required String likes,
    required String comments,
    required String shares,
    required String postId,
    required String privacy}) {
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
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
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
                            radius: 20,
                            backgroundImage: NetworkImage(avatarUrl),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userName,
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              Visibility(
                                visible: subName != null,
                                child: Text(
                                  subName ?? "",
                                  style: const TextStyle(color: Colors.black54),
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    "$createdAt • ",
                                    style: const TextStyle(
                                        color: Colors.grey, fontSize: 11),
                                  ),
                                  Icon(
                                    privacy == "Public"
                                        ? Icons.public
                                        : Icons.group,
                                    color: Colors.grey,
                                    size: 11,
                                  )
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // SizedBox(
                          //   height: 25,
                          //   child: ElevatedButton(
                          //       onPressed: () {},
                          //       style: ElevatedButton.styleFrom(
                          //           padding: const EdgeInsets.symmetric(
                          //               horizontal: 10),
                          //           shape: RoundedRectangleBorder(
                          //               borderRadius:
                          //                   BorderRadius.circular(20)),
                          //           backgroundColor: Colors.blueGrey.shade50),
                          //       child: const Text(
                          //         "Theo dõi",
                          //         style: TextStyle(
                          //             color: Colors.black, fontSize: 12),
                          //       )),
                          // ),
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
                  contentWidget(content),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Visibility(
                visible: images.isNotEmpty,
                child: PostImageWidget(mediaUrl: images, postId: postId)),
            // Visibility(
            //     visible: images.isNotEmpty,
            //     child: FBPhotoView(
            //       dataSource: images,
            //       displayType: FBPhotoViewType.grid3,
            //     )),
            const SizedBox(
              height: 10,
            ),
            engagementWidget(
                ref: ref,
                postId: postId,
                context: context,
                likeCount: likes,
                commentCount: comments,
                shareCount: shares),
            const SizedBox(
              height: 8,
            ),
          ],
        )
      ],
    ),
  );
}

Widget contentWidget(String content) {
  return ReadMoreText(
    content,
    trimMode: TrimMode.Line,
    trimLines: 2,
    colorClickableText: Colors.black,
    trimCollapsedText: "Xem thêm",
    trimExpandedText: "Thu gọn",
    moreStyle: const TextStyle(fontWeight: FontWeight.bold),
  );
}
