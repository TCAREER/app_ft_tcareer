import 'package:app_tcareer/src/modules/posts/presentation/controllers/comment_controller.dart';
import 'package:app_tcareer/src/modules/posts/presentation/posts_provider.dart';
import 'package:app_tcareer/src/modules/posts/presentation/widgets/comment_video_player.dart';
import 'package:app_tcareer/src/shared/utils/app_utils.dart';
import 'package:app_tcareer/src/shared/widgets/cached_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_tcareer/src/shared/extensions/video_extension.dart';

Widget commentItemWidget(int commentId, Map<dynamic, dynamic> comment,
    WidgetRef ref, BuildContext context) {
  final controller = ref.watch(commentControllerProvider);

  String userName = comment['full_name'];
  String content = comment['content'];
  String? avatar = comment['avatar'];
  String createdAt = AppUtils.formatTime(comment['created_at']);
  List<String> mediaUrl =
      (comment['media_url'] as List?)?.whereType<String>().toList() ?? [];

  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        flex: 1,
        child: Column(
          children: [
            CircleAvatar(
              radius: 15,
              backgroundImage: NetworkImage(avatar != null
                  ? avatar
                  : "https://ui-avatars.com/api/?name=$userName&background=random"),
            ),
          ],
        ),
      ),
      Expanded(
        flex: 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              userName,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            Text(
              content,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
            SizedBox(
              height: 5,
            ),
            Visibility(
              visible: mediaUrl.isNotEmpty,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: mediaUrl.map((image) {
                    return Visibility(
                      visible: !mediaUrl.hasVideos,
                      replacement: CommentVideoPlayerWidget(image),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: cachedImageWidget(
                            imageUrl: image,
                            fit: BoxFit.cover,
                            height: 100,
                            width: 100),
                      ),
                    );
                  }).toList()),
            ),
            SizedBox(
              height: 5,
            ),
            SizedBox(
              width: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    createdAt,
                    style: TextStyle(color: Colors.black38, fontSize: 10),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      FocusScope.of(context).requestFocus();

                      controller.setRepComment(
                          fullName: userName.toString(), commentId: commentId);
                    },
                    child: Text(
                      "Trả lời",
                      style: TextStyle(color: Colors.black54, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
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
