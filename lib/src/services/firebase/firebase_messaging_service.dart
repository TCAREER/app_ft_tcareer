import 'package:app_tcareer/app.dart';
import 'package:app_tcareer/main.dart';
import 'package:app_tcareer/src/services/notifications/notification_service.dart';
import 'package:app_tcareer/src/utils/user_utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class FirebaseMessagingService {
  final NotificationService notificationService;
  final UserUtils userUtils;
  final Ref ref;
  FirebaseMessagingService(this.notificationService, this.userUtils, this.ref);
  FirebaseMessaging fcm = FirebaseMessaging.instance;
  void configureFirebaseMessaging() async {
    String? deviceToken = await fcm.getToken();
    await userUtils.saveDeviceToken(deviceToken: deviceToken ?? "");
    print(">>>>>>>>>>deviceToken: $deviceToken");
    fcm.subscribeToTopic("tcareer");
    fcm.getInitialMessage().then((RemoteMessage? message) {
      directToPage(message);
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
      notificationService.displayNotification(message);
    });
  }

  void directToPage(RemoteMessage? message) {
    final navigatorKey = ref.watch(navigatorKeyProvider);
    final context = navigatorKey.currentContext;
    if (message != null) {
      if (message.data["post_id"] != null) {
        String postId = message.data["post_id"];
        context?.goNamed("detail/$postId");
      }
    }
  }
}

final firebaseMessagingServiceProvider =
    Provider<FirebaseMessagingService>((ref) {
  final notificationService = ref.watch(notificationServiceProvider);
  final userUtils = ref.watch(userUtilsProvider);
  return FirebaseMessagingService(notificationService, userUtils, ref);
});
