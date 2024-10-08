import 'package:app_tcareer/src/features/notifications/presentation/controllers/notification_controller.dart';
import 'package:app_tcareer/src/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Widget notificationItem(
    Map<String, dynamic> notification, BuildContext context, WidgetRef ref) {
  final controller = ref.watch(notificationControllerProvider);
  String fullName = notification['full_name'];
  String avatar = notification['avatar'] ??
      "https://ui-avatars.com/api/?name=$fullName&background=random";
  String content = notification['content'];
  String updatedAt = AppUtils.formatTime(notification['updated_at']);
  int? postId = notification['post_id'];
  int? relatedUserId = notification['related_user_id'];
  String? type = notification['type'];

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
    child: GestureDetector(
      onTap: () => controller.directToPage(
          context: context,
          postId: postId,
          relatedUserId: relatedUserId,
          type: type),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(avatar),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  content,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.normal),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  updatedAt,
                  style: const TextStyle(color: Colors.grey, fontSize: 10),
                ),
                const SizedBox(
                  height: 10,
                ),
                Divider(
                  height: 1,
                  color: Colors.grey.shade100,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}