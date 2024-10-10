import 'package:app_tcareer/app.dart';
import 'package:app_tcareer/main.dart';
import 'package:app_tcareer/src/services/notifications/notification_service.dart';
import 'package:app_tcareer/src/utils/user_utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:overlay_support/overlay_support.dart';

class FirebaseMessagingService {
  final NotificationService notificationService;
  final UserUtils userUtils;
  final Ref ref;
  final GlobalKey<NavigatorState> navigatorKey;
  FirebaseMessagingService(
      this.notificationService, this.userUtils, this.ref, this.navigatorKey);
  FirebaseMessaging fcm = FirebaseMessaging.instance;
  void configureFirebaseMessaging() async {
    String? deviceToken = await fcm.getToken();
    await userUtils.saveDeviceToken(deviceToken: deviceToken ?? "");
    print(">>>>>>>>>>deviceToken: $deviceToken");
    fcm.subscribeToTopic("tcareer");
    fcm.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        directToPage(message);
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      directToPage(message);
    });

    await fcm.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    await fcm.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void handleForegroundMessage() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kIsWeb) {
        String fullName = message.data['full_name'];
        String image = message.notification?.android?.imageUrl ??
            "https://ui-avatars.com/api/?name=$fullName&background=random";
        showSimpleNotification(
          background: Colors.white,
          duration: Duration(seconds: 5),
          ListTile(
            onTap: () async => await directToPage(message),
            leading: Image.network(
              image,
              fit: BoxFit.cover,
            ),
            title: Text(
              message.notification?.title ?? "",
              style: TextStyle(color: Colors.black),
            ),
            subtitle: Text(
              message.notification?.body ?? "",
              style: TextStyle(color: Colors.black45),
            ),
          ),
        );
      } else {
        notificationService.displayNotification(message);
      }
    });
  }

  Future<void> directToPage(RemoteMessage message) async {
    final context = navigatorKey.currentContext;
    final data = message.data;

    final postId = data["post_id"]?.toString();
    final userId = data['related_user_id']?.toString();
    final type = data['type']?.toString();

    if (postId != null && type?.contains("COMMENT") == true) {
      context?.pushNamed(
        "detail",
        pathParameters: {"id": postId},
        queryParameters: {"notificationType": type},
      );
    } else if (postId != null) {
      context?.pushNamed(
        "detail",
        pathParameters: {"id": postId},
      );
    } else if (userId != null) {
      context?.pushNamed(
        'profile',
        queryParameters: {"userId": userId},
      );
    }
  }
}

final firebaseMessagingServiceProvider =
    Provider.family<FirebaseMessagingService, GlobalKey<NavigatorState>>(
        (ref, navigatorKey) {
  final notificationService =
      ref.watch(notificationServiceProvider(navigatorKey));
  final userUtils = ref.watch(userUtilsProvider);
  return FirebaseMessagingService(
      notificationService, userUtils, ref, navigatorKey);
});

Future<void> backgroundHandler(RemoteMessage message) async {
  final context = navigatorKey.currentContext;
  final data = message.data;

  final postId = data["post_id"]?.toString();
  final userId = data['related_user_id']?.toString();
  final type = data['type']?.toString();

  if (postId != null && type?.contains("COMMENT") == true) {
    context?.pushNamed(
      "detail",
      pathParameters: {"id": postId},
      queryParameters: {"notificationType": type},
    );
  } else if (postId != null) {
    context?.pushNamed(
      "detail",
      pathParameters: {"id": postId},
    );
  } else if (userId != null) {
    context?.pushNamed(
      'profile',
      queryParameters: {"userId": userId},
    );
  }
}
