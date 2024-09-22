import 'package:app_tcareer/src/modules/posts/presentation/controllers/comment_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Widget commentItemWidget(int index, Map<dynamic, dynamic> comment,
    WidgetRef ref, BuildContext context) {
  final controller = ref.watch(commentControllerProvider);
  final comments = controller.commentData?.entries.toList();
  int commentId = int.parse(comments?[index].key);
  print(">>>>>>>>>>commentId: $commentId");
  int userName = comment['user_id'];
  String content = comment['content'];

  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Expanded(
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
                  text: "$userName ",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                        text: '1giờ',
                        style: TextStyle(fontSize: 12, color: Colors.black54))
                  ]),
            ),
            Text(
              content,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
            SizedBox(
              height: 5,
            ),
            GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus();

                controller.setRepComment(
                    userName: userName.toString(), commentId: commentId);
              },
              child: Text(
                "Trả lời",
                style: TextStyle(color: Colors.black54, fontSize: 12),
              ),
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
