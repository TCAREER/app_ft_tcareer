import 'package:app_tcareer/src/services/firebase/firebase_database_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationRepository {
  final Ref ref;

  NotificationRepository(this.ref);

  Stream<DatabaseEvent> listenToNotifications() {
    final database = ref.watch(firebaseDatabaseServiceProvider);
    String path = "notification";
    return database.listenToData(path);
  }
}

final notificationRepositoryProvider =
    Provider((ref) => NotificationRepository(ref));
