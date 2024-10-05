import 'package:app_tcareer/main.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app.dart';

class NotificationService {
  GlobalKey<NavigatorState> navigatorKey;
  NotificationService(this.navigatorKey);
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
    print(">>>>>>>>>>>data = ${message.data}");
    String fullName = message.data['full_name'];
    String image = message.notification?.android?.imageUrl ??
        "https://ui-avatars.com/api/?name=$fullName&background=random";
    // String postId = message.data["id"];
    int notificationId =
        DateTime.now().millisecondsSinceEpoch.remainder(100000);
    if (message.notification != null) {
      AwesomeNotifications().createNotification(
          content: NotificationContent(
              payload: {
            "post_id": message.data["post_id"],
            "related_user_id": message.data['related_user_id']
          },
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
      await AwesomeNotifications()
          .setListeners(onActionReceivedMethod: onActionReceivedMethod);
    }
  }

  Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
    directToPage(receivedAction);
  }

  void directToPage(ReceivedAction receivedAction) {
    print(">>>>>>>123");
    print(">>>>>>>>>>>>>payload: ${receivedAction.payload}");
    print(">>>>>>>>>>>>>navigatorKey: $navigatorKey");

    if (receivedAction.payload?["post_id"] != null) {
      String postId = receivedAction.payload?["post_id"].toString() ?? "";
      navigatorKey.currentContext
          ?.pushNamed("detail", pathParameters: {"id": postId});
    }
    if (receivedAction.payload?["related_user_id"] != null) {
      String userId =
          receivedAction.payload?['related_user_id'].toString() ?? "";
      navigatorKey.currentContext?.pushNamed('profile',
          queryParameters: {"userId": userId.toString()});
    }
  }
}

final notificationServiceProvider =
    Provider.family<NotificationService, GlobalKey<NavigatorState>>(
        (ref, navigatorKey) {
  return NotificationService(navigatorKey);
});
