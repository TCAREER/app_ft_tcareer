import 'package:app_tcareer/src/features/notifications/data/repositories/notification_repository.dart';
import 'package:app_tcareer/src/utils/app_utils.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationUseCase {
  final NotificationRepository notificationRepository;

  NotificationUseCase(this.notificationRepository);

  Stream<List<Map<String, dynamic>>> listenToNotificationsByUserId(int userId) {
    return notificationRepository.listenToNotifications().map((event) {
      final rawData = event.snapshot.value;

      // Log rawData trước khi xử lý
      print("Raw data: $rawData");

      if (rawData is Map) {
        final notifications = rawData.entries.where((entry) {
          final element = entry.value;
          if (element == null) return false;

          if (element is Map && element['user_id'] != null) {
            return element['user_id'].toString() == userId.toString();
          }
          return false;
        }).map((entry) {
          final notificationId = entry.key; // Lấy ID từ key của map
          final updatedElement = Map<String, dynamic>.from(entry.value);
          updatedElement['notification_id'] =
              notificationId; // Thêm notification_id
          return updatedElement;
        }).toList();

        // Log notifications sau khi được chuyển đổi
        print("Notifications: $notifications");

        notifications.sort((a, b) {
          final updatedA = a['updated_at'];
          final updatedB = b['updated_at'];

          if (updatedA == null || updatedB == null) {
            print("Một trong hai giá trị là null");
            return 0; // Hoặc xử lý theo cách bạn muốn
          }

          try {
            DateTime dateA =
                DateTime.parse(AppUtils.convertToISOFormat(updatedA));
            DateTime dateB =
                DateTime.parse(AppUtils.convertToISOFormat(updatedB));
            return dateB.compareTo(dateA);
          } catch (e) {
            return 0; // Để chúng ở vị trí hiện tại nếu có lỗi
          }
        });

        return notifications;
      } else {
        print("Dữ liệu không phải là Map");
        return [];
      }
    });
  }

  Future<void> readNotification(String notificationId) async =>
      await notificationRepository.readNotification(notificationId);
}

final notificationUseCaseProvider = Provider((ref) {
  final notificationRepository = ref.watch(notificationRepositoryProvider);
  return NotificationUseCase(notificationRepository);
});
