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

        notifications.sort((a, b) {
          final updatedA = a['updated_at'];
          final updatedB = b['updated_at'];

          // Log giá trị trước khi phân tích
          // print("updatedA: $updatedA");
          // print("updatedB: $updatedB");

          if (updatedA == null || updatedB == null) {
            print("Một trong hai giá trị là null");
            return 0; // Hoặc xử lý theo cách bạn muốn
          }

          try {
            DateTime dateA =
                DateTime.parse(AppUtils.convertToISOFormat(updatedA));
            // print(">>>>>>>>>>dateA: $dateA");
            DateTime dateB =
                DateTime.parse(AppUtils.convertToISOFormat(updatedB));
            return dateB.compareTo(dateA);
          } catch (e) {
            return 0; // Để chúng ở vị trí hiện tại nếu có lỗi
          }
        });

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
