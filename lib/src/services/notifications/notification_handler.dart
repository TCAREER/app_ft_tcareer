import 'package:app_tcareer/src/services/firebase/firebase_messaging_service.dart';
import 'package:app_tcareer/src/services/notifications/notification_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationHandler {
  final FirebaseMessagingService firebaseMessagingService;
  final NotificationService notificationService;
  NotificationHandler(this.firebaseMessagingService, this.notificationService);

  void initializeNotificationServices() {
    notificationService.initialize();
    firebaseMessagingService.configureFirebaseMessaging();
    firebaseMessagingService.handleForegroundMessage();
  }
}

final notificationProvider = Provider<NotificationHandler>((ref) {
  final firebaseMessagingService = ref.watch(firebaseMessagingServiceProvider);
  final notificationService = ref.watch(notificationServiceProvider);
  return NotificationHandler(firebaseMessagingService, notificationService);
});
