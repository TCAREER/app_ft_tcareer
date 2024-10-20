import 'package:app_tcareer/src/features/user/data/repositories/user_repository.dart';
import 'package:app_tcareer/src/utils/user_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConnectionUseCase {
  final UserRepository userRepository;
  final Ref ref;
  ConnectionUseCase(this.userRepository, this.ref);

  Future<void> monitorConnection() async {
    final userUtils = ref.watch(userUtilsProvider);
    if (await userUtils.isAuthenticated()) {
      userRepository.monitorConnection(
        (event) {
          final connected = event.snapshot.value as bool;
          print(">>>>>>>>>connected: $connected");
          if (connected) {
            setUserOnlineStatus();
          } else {
            setUserOfflineStatus();
          }
        },
      );
    }
  }

  void setUserOnlineStatus() async {
    final userUtil = ref.watch(userUtilsProvider);
    String userId = await userUtil.getUserId();
    Map<String, dynamic> data = {
      "userId": userId,
      "status": "online",
      "updatedAt": DateTime.now().toIso8601String(),
    };
    userRepository
        .addData(path: "users/$userId", data: data, dataUpdateDisconnect: {
      "status": "offline",
      "updatedAt": DateTime.now().toIso8601String(),
    });
  }

  Future<void> setUserOfflineStatus() async {
    final userUtil = ref.watch(userUtilsProvider);
    String userId = await userUtil.getUserId();
    Map<String, dynamic> data = {
      "status": "offline",
      "updatedAt": DateTime.now().toIso8601String(),
    };
    userRepository.addData(path: "users/$userId", data: data);
  }
}

final connectionUseCaseProvider = Provider((ref) {
  final userRepository = ref.watch(userRepositoryProvider);
  return ConnectionUseCase(userRepository, ref);
});
