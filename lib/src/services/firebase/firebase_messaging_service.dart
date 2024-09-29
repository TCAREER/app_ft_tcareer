import 'package:app_tcareer/src/services/notifications/notification_service.dart';
import 'package:app_tcareer/src/utils/user_utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FirebaseMessagingService {
  final NotificationService notificationService;
  final UserUtils userUtils;
  FirebaseMessagingService(this.notificationService, this.userUtils);
  FirebaseMessaging fcm = FirebaseMessaging.instance;
  void configureFirebaseMessaging() async {
    String? deviceToken = await fcm.getToken();
    await userUtils.saveDeviceToken(deviceToken: deviceToken ?? "");
    print(">>>>>>>>>>deviceToken: $deviceToken");
    fcm.subscribeToTopic("tcareer");
    fcm.getInitialMessage();
    FirebaseMessaging.onMessageOpenedApp
        .listen((RemoteMessage message) async {});

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
}

final firebaseMessagingServiceProvider =
    Provider<FirebaseMessagingService>((ref) {
  final notificationService = ref.watch(notificationServiceProvider);
  final userUtils = ref.watch(userUtilsProvider);
  return FirebaseMessagingService(notificationService, userUtils);
});
