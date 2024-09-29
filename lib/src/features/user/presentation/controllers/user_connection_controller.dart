import 'package:app_tcareer/src/features/user/usercases/user_connection_use_case.dart';
import 'package:app_tcareer/src/utils/snackbar_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserConnectionController extends ChangeNotifier {
  final UserConnectionUseCase connectionUseCase;
  final Ref ref;
  UserConnectionController(this.connectionUseCase, this.ref);

  Future<void> postFollow(String userId) async {
    await connectionUseCase.postFollow(userId);
    showSnackBar("Bạn đã theo dõi");
    notifyListeners();
  }

  Future<void> postAddFriend(String userId) async {
    await connectionUseCase.postAddFriend(userId);
    notifyListeners();
  }
}

final userConnectionControllerProvider = ChangeNotifierProvider((ref) {
  final userUseCase = ref.watch(userUseCaseProvider);

  return UserConnectionController(userUseCase, ref);
});
