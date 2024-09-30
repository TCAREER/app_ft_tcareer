import 'package:app_tcareer/src/features/user/presentation/controllers/another_user_controller.dart';
import 'package:app_tcareer/src/features/user/usercases/user_connection_use_case.dart';
import 'package:app_tcareer/src/utils/snackbar_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class UserConnectionController extends ChangeNotifier {
  final UserConnectionUseCase connectionUseCase;
  final Ref ref;
  UserConnectionController(this.connectionUseCase, this.ref);

  Future<void> postFollow(String userId, BuildContext context) async {
    // Đọc `AnotherUserController` từ provider
    final anotherUser = ref.watch(anotherUserControllerProvider.notifier);

    // Lấy đối tượng `anotherUserData` và `currentFollowed`
    final currentUser = anotherUser.anotherUserData;
    final updateUser =
        await connectionUseCase.postFollow(userId: userId, user: currentUser!);
    anotherUser.anotherUserData = updateUser;
    context.pop();
    if (currentUser.data?.followed != true) {
      showSnackBar(
          "Bạn đã theo dõi ${anotherUser.anotherUserData?.data?.fullName}");
    }
    notifyListeners();
  }

  Future<void> postAddFriend(String userId) async {
    final anotherUser = ref.watch(anotherUserControllerProvider.notifier);

    await connectionUseCase.postAddFriend(userId: userId);
    await anotherUser.getUserById(userId);
    showSnackBar(
        "Đã gửi lời mời kết bạn đến ${anotherUser.anotherUserData?.data?.fullName}");
    notifyListeners();
  }

  Future<void> postAcceptFriend(String userId) async {
    final anotherUser = ref.watch(anotherUserControllerProvider.notifier);
    final currentUser = anotherUser.anotherUserData;
    await connectionUseCase.postAcceptFriend(
      userId: userId,
    );
    await anotherUser.getUserById(userId);
    showSnackBar("Bạn đã đồng ý kết bạn với ${currentUser?.data?.fullName}");
    notifyListeners();
  }

  Future<void> postDeclineFriend(String userId) async {
    final anotherUser = ref.watch(anotherUserControllerProvider.notifier);
    final currentUser = anotherUser.anotherUserData;
    await connectionUseCase.postDeclineFriend(
      userId,
    );
    await anotherUser.getUserById(userId);
    showSnackBar("Đã hủy kết bạn với ${currentUser?.data?.fullName}");
    notifyListeners();
  }

  Future<void> showModalDeleteFriend(
      {required BuildContext context, required String userId}) async {
    final anotherUser = ref.watch(anotherUserControllerProvider.notifier);
    final currentUser = anotherUser.anotherUserData?.data;
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: Column(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(currentUser?.avatar ??
                    "https://ui-avatars.com/api/?name=${currentUser?.fullName}&background=random"),
              ),
            ],
          ),
          message: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Text(
              'Hủy kết bạn với ${currentUser?.fullName}',
              style: TextStyle(color: Colors.black),
            ),
          ),
          actions: <Widget>[
            CupertinoActionSheetAction(
                isDestructiveAction: true,
                onPressed: () async {},
                child: const Text(
                  'Hủy kết bạn',
                  style: TextStyle(fontSize: 12),
                )),
          ],
          cancelButton: CupertinoActionSheetAction(
              isDefaultAction: true,
              child: const Text(
                'Quay lại',
                style: TextStyle(color: Colors.black, fontSize: 12),
              ),
              onPressed: () => context.pop()),
        );
      },
    );
  }
}

final userConnectionControllerProvider = ChangeNotifierProvider((ref) {
  final userUseCase = ref.watch(userUseCaseProvider);

  return UserConnectionController(userUseCase, ref);
});
