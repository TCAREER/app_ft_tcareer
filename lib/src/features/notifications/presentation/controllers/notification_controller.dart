import 'package:app_tcareer/src/features/notifications/usecases/notification_use_case.dart';
import 'package:app_tcareer/src/features/user/presentation/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationController extends ChangeNotifier {
  final NotificationUseCase notificationUseCase;
  final Ref ref;
  NotificationController(this.notificationUseCase, this.ref);
  Stream<List<Map<String, dynamic>>> notificationsStream() {
    final userController = ref.watch(userControllerProvider);
    final user = userController.userData?.data;
    int userId = user?.id?.toInt() ?? 0;
    return notificationUseCase.listenToNotificationsByUserId(userId);
  }
}

final notificationControllerProvider = Provider((ref) {
  final notificationUseCase = ref.watch(notificationUseCaseProvider);
  return NotificationController(notificationUseCase, ref);
});
