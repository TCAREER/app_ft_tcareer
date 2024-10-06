import 'package:app_tcareer/src/features/notifications/data/repositories/notification_repository.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationUseCase {
  final NotificationRepository notificationRepository;

  NotificationUseCase(this.notificationRepository);

  Stream<List<Map<String, dynamic>>> listenToNotificationsByUserId(int userId) {
    return notificationRepository.listenToNotifications().map((event) {
      final rawData = event.snapshot.value;
      if (rawData is List) {
        final notifications = rawData
            .where((element) {
              if (element == null) return false;

              if (element is Map && element['user_id'] != null) {
                // print('Element: $element'); // Kiểm tra từng phần tử
                return element['user_id'].toString() == userId.toString();
              }
              return false;
            })
            .map((element) => Map<String, dynamic>.from(element))
            .toList();

        // print(
        //     'Filtered notifications: $notifications'); // Kiểm tra thông báo đã lọc
        return notifications;
      } else {
        return [];
      }
    });
  }
}

final notificationUseCaseProvider = Provider((ref) {
  final notificationRepository = ref.watch(notificationRepositoryProvider);
  return NotificationUseCase(notificationRepository);
});
