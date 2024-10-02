import 'package:app_tcareer/src/features/notifications/presentation/controllers/notification_controller.dart';
import 'package:app_tcareer/src/utils/app_utils.dart';
import 'package:app_tcareer/src/widgets/circular_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationPage extends ConsumerWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: false,
        title: Text(
          "Thông báo",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: notifications(ref),
    );
  }

  Widget notifications(WidgetRef ref) {
    final controller = ref.watch(notificationControllerProvider);
    return StreamBuilder<List<Map<String, dynamic>>>(
        stream: controller.notificationsStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularLoadingWidget();
          }
          final notifications = snapshot.data;
          return ListView.separated(
            separatorBuilder: (context, index) => const SizedBox(
              height: 10,
            ),
            itemCount: notifications?.length ?? 0,
            itemBuilder: (context, index) {
              final notification = notifications?[index];
              return item(notification!);
            },
          );
        });
  }

  Widget item(Map<String, dynamic> notification) {
    String avatar = notification['avatar'];
    String content = notification['content'];
    String updatedAt = AppUtils.formatTime(notification['updated_at']);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
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
                      fontSize: 15, fontWeight: FontWeight.bold),
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
    );
  }
}
