import 'package:app_tcareer/src/modules/posts/presentation/widgets/video_player_widget.dart';
import 'package:app_tcareer/src/shared/extensions/video_extension.dart';
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

Widget postWidget({
  bool isShared = false,
  required BuildContext context,
  required WidgetRef ref,
  required String avatarUrl,
  required String userName,
  String? subName,
  required String createdAt,
  required String content,
  List<String>? mediaUrl,
  required bool liked,
  required String likes,
  required String comments,
  required String shares,
  required String postId,
  required int index,
  required String privacy,
}) {
  final hasMediaUrl = mediaUrl != null && mediaUrl.isNotEmpty;
  final firstMediaUrl = hasMediaUrl ? mediaUrl.first : "";

  return Container(
    width: ScreenUtil().screenWidth,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundImage: NetworkImage(avatarUrl),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 5),
                  Column(
                    children: [
                      Text(
                        userName,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      if (subName != null) ...[
                        Text(subName, style: TextStyle(color: Colors.grey)),
                      ],
                    ],
                  ),
                  Expanded(
                    flex: 7,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          height: 25,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side:
                                      BorderSide(color: Colors.grey.shade100)),
                              backgroundColor: Colors.white,
                            ),
                            child: const Text(
                              "Theo dõi",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        const PhosphorIcon(
                          PhosphorIconsLight.dotsThreeCircle,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Hiển thị video hoặc ảnh
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: contentWidget(content),
            ),
            const SizedBox(
              height: 5,
            ),
            Visibility(
              visible: hasMediaUrl,
              child: Visibility(
                visible: mediaUrl?.hasVideos ?? false,
                replacement:
                    PostImageWidget(mediaUrl: mediaUrl ?? [], postId: postId),
                child: VideoPlayerWidget(videoUrl: firstMediaUrl),
              ),
            ),

            const SizedBox(height: 5),
            Visibility(
                visible: !isShared,
                child: Column(
                  children: [
                    engagementWidget(
                      index: index,
                      liked: liked,
                      ref: ref,
                      postId: postId,
                      context: context,
                      likeCount: likes,
                      shareCount: shares,
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          Text(
                            "$createdAt • ",
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 11),
                          ),
                          Icon(
                            privacy == "Public" ? Icons.public : Icons.group,
                            color: Colors.grey,
                            size: 11,
                          ),
                        ],
                      ),
                    ),
                  ],
                ))
          ],
        ),
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
