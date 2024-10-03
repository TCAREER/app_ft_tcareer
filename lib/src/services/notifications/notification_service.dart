import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationService {
  void initialize() async {
    AwesomeNotifications().initialize(null, [
      NotificationChannel(
        playSound: true,
        channelShowBadge: true,
        criticalAlerts: true,
        importance: NotificationImportance.Max,
        channelGroupKey: 'notify_group',
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelDescription: 'Notification channel for basic notifications',
      )
    ], channelGroups: [
      NotificationChannelGroup(
        channelGroupKey: 'notify_group',
        channelGroupName: 'push notify group',
      )
    ]);
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }
  }

  Future<void> displayNotification(RemoteMessage message) async {
    String image = message.notification?.android?.imageUrl ?? "";
    print(">>>>>>>>>>>data = ${message.data}");
    // String postId = message.data["id"];
    int notificationId =
        DateTime.now().millisecondsSinceEpoch.remainder(100000);
    if (message.notification != null) {
      AwesomeNotifications().createNotification(
          content: NotificationContent(
              displayOnForeground: true,
              displayOnBackground: true,
              roundedLargeIcon: false,
              wakeUpScreen: true,
              largeIcon: image,
              id: notificationId,
              channelKey: 'basic_channel',
              title: message.notification?.title,
              body: message.notification?.body,
              notificationLayout: NotificationLayout.BigText));
      await AwesomeNotifications().shouldShowRationaleToRequest();
    }
  }
}

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});
