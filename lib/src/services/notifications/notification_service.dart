import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationService {
  void initialize() {
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
  }

  Future<void> displayNotification(RemoteMessage message) async {
    int notificationId =
        DateTime.now().millisecondsSinceEpoch.remainder(100000);
    if (message.notification != null) {
      AwesomeNotifications().createNotification(
          content: NotificationContent(
              id: notificationId,
              channelKey: 'basic chanel',
              title: message.notification?.title,
              body: message.notification?.body,
              notificationLayout: NotificationLayout.Default));
    }
  }
}

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});
