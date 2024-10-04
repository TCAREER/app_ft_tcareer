import 'package:app_tcareer/src/features/notifications/data/repositories/notification_repository.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationUseCase {
  final NotificationRepository notificationRepository;
  NotificationUseCase(this.notificationRepository);

  Stream<List<Map<String, dynamic>>> listenToNotificationsByUserId(int userId) {
    final data = notificationRepository.listenToNotifications();

    return notificationRepository.listenToNotifications().map((event) {
      final data = Map<String, dynamic>.from(event.snapshot.value as Map);
      final notifications = data.entries
          .where((entry) => entry.value['user_id'] == userId)
          .map((entry) => Map<String, dynamic>.from(entry.value))
          .toList();

      return notifications;
    });
  }
}

final notificationUseCaseProvider = Provider((ref) {
  final notificationRepository = ref.watch(notificationRepositoryProvider);
  return NotificationUseCase(notificationRepository);
});
