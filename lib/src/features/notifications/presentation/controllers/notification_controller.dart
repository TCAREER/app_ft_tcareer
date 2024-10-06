import 'package:app_tcareer/src/features/index/index_controller.dart';
import 'package:app_tcareer/src/features/notifications/usecases/notification_use_case.dart';
import 'package:app_tcareer/src/features/posts/presentation/pages/comments_page.dart';
import 'package:app_tcareer/src/features/user/presentation/controllers/user_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class NotificationController extends ChangeNotifier {
  final NotificationUseCase notificationUseCase;
  final Ref ref;
  NotificationController(this.notificationUseCase, this.ref);
  Stream<List<Map<String, dynamic>>> notificationsStream() {
    final userController = ref.watch(userControllerProvider);
    final user = userController.userData?.data;
    int userId = user?.id?.toInt() ?? 0;

    final data = notificationUseCase.listenToNotificationsByUserId(userId);

    return data;
  }

  Future<void> directToPage(
      {required BuildContext context,
      int? relatedUserId,
      int? postId,
      String? type}) async {
    print(">>>>>>>>>>userId: $relatedUserId");
    print(">>>>>>>>>>>>postId: $postId");
    if (postId != null) {
      context.pushNamed("detail", pathParameters: {"id": postId.toString()});
    }
    if (relatedUserId != null) {
      context.pushNamed('profile',
          queryParameters: {"userId": relatedUserId.toString()});
    }
    if (type?.contains("COMMENT") == true && postId != null) {
      context.pushNamed("detail",
          pathParameters: {"id": postId.toString()},
          queryParameters: {"notificationType": type});
    }
  }
}

final notificationControllerProvider = Provider((ref) {
  final notificationUseCase = ref.watch(notificationUseCaseProvider);
  return NotificationController(notificationUseCase, ref);
});
