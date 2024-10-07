import 'package:app_tcareer/src/features/index/index_controller.dart';
import 'package:app_tcareer/src/features/user/data/models/users.dart';
import 'package:app_tcareer/src/features/user/presentation/controllers/another_user_controller.dart';
import 'package:app_tcareer/src/features/user/presentation/controllers/user_controller.dart';
import 'package:app_tcareer/src/features/user/presentation/pages/user_list_page.dart';
import 'package:app_tcareer/src/features/user/usercases/user_connection_use_case.dart';
import 'package:app_tcareer/src/features/user/usercases/user_use_case.dart';
import 'package:app_tcareer/src/utils/snackbar_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class UserConnectionController extends ChangeNotifier {
  final UserConnectionUseCase connectionUseCase;
  final AnotherUserController anotherUserController;
  final UserUseCase userUseCase;
  final Ref ref;
  UserConnectionController(this.connectionUseCase, this.ref, this.userUseCase,
      this.anotherUserController);

  Future<void> postFollow(String userId, BuildContext context) async {
    // Đọc `AnotherUserController` từ provider

    // Lấy đối tượng `anotherUserData` và `currentFollowed`
    final currentUser = anotherUserController.anotherUserData;
    final updateUser =
        await connectionUseCase.postFollow(userId: userId, user: currentUser!);
    anotherUserController.anotherUserData = updateUser;
    context.pop();
    if (currentUser.data?.followed != true) {
      showSnackBar("Bạn đã theo dõi ${currentUser.data?.fullName}");
    }
    notifyListeners();
  }

  Future<void> postAddFriend(String userId) async {
    await connectionUseCase.postAddFriend(userId: userId);
    await anotherUserController.getUserById(userId);
    showSnackBar(
        "Đã gửi lời mời kết bạn đến ${anotherUserController.anotherUserData?.data?.fullName}");
    notifyListeners();
  }

  Future<void> postAcceptFriend(BuildContext context, String userId) async {
    final currentUser = anotherUserController.anotherUserData;
    await connectionUseCase.postAcceptFriend(
      userId: userId,
    );
    await anotherUserController.getUserById(userId);
    context.pop();
    showSnackBar("Bạn đã đồng ý kết bạn với ${currentUser?.data?.fullName}");
    notifyListeners();
  }

  Future<void> postDeclineFriend(BuildContext context, String userId) async {
    final anotherUser = ref.watch(anotherUserControllerProvider.notifier);
    final currentUser = anotherUser.anotherUserData;
    await connectionUseCase.postDeclineFriend(
      userId,
    );
    await anotherUser.getUserById(userId);
    context.pop();
    showSnackBar("Đã từ chối kết bạn với ${currentUser?.data?.fullName}");
    notifyListeners();
  }

  Future<void> showModalDeleteFriend(
      {required BuildContext context, required String userId}) async {
    final currentUser = anotherUserController.anotherUserData?.data;
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
                onPressed: () async => await unFriend(context, userId),
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

  Future<void> showModalConfirmRequest(
      {required BuildContext context, required String userId}) async {
    final currentUser = anotherUserController.anotherUserData?.data;
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
              'Kết bạn với ${currentUser?.fullName}',
              style: TextStyle(color: Colors.black),
            ),
          ),
          actions: <Widget>[
            CupertinoActionSheetAction(
                // isDestructiveAction: true,
                onPressed: () async => await postAcceptFriend(context, userId),
                child: const Text(
                  'Xác nhận',
                  style: TextStyle(color: Colors.black, fontSize: 12),
                )),
          ],
          cancelButton: CupertinoActionSheetAction(
              isDestructiveAction: true,
              child: const Text(
                'Hủy',
                style: TextStyle(fontSize: 12),
              ),
              onPressed: () async => await postDeclineFriend(context, userId)),
        );
      },
    );
  }

  List<Data> followers = [];
  Future<void> getFollowers(String userId) async {
    followers.clear();
    notifyListeners();
    final data = await userUseCase.getFollowers(userId);
    List<dynamic> followerJson = data['data'];
    await mapFollowerFromJson(followerJson);
    notifyListeners();
  }

  Future<void> mapFollowerFromJson(List<dynamic> followerJson) async {
    followers = followerJson
        .whereType<Map<String, dynamic>>()
        .map((item) => Data.fromJson(item))
        .toList();
  }

  Future<void> showUserFollowed(BuildContext context, String userId) async {
    final index = ref.watch(indexControllerProvider.notifier);

    // index.showBottomSheet(
    //     context: context, builder: (scrollController) => SharePage());
    // await getUserLikePost(postId);
    index.setBottomNavigationBarVisibility(false);
    showModalBottomSheet(
      backgroundColor: Colors.white,
      isScrollControlled: true,
      context: context,
      builder: (context) => SizedBox(
        height: ScreenUtil().screenHeight * .7,
        child: UserListPage(
          userId: userId,
        ),
      ),
    ).whenComplete(
      () => index.setBottomNavigationBarVisibility(true),
    );
  }

  Future<void> cancelRequest(String userId) async {
    await connectionUseCase.deleteCancelRequest(userId);
    await anotherUserController.getUserById(userId);
    final currentUser = anotherUserController.anotherUserData;
    showSnackBar("Đã hủy lời mời kết bạn với ${currentUser?.data?.fullName}");
  }

  Future<void> unFriend(BuildContext context, String userId) async {
    await connectionUseCase.deleteUnFriend(userId);
    await anotherUserController.getUserById(userId);
    final currentUser = anotherUserController.anotherUserData;
    context.pop();
    showSnackBar("Đã hủy kết bạn với ${currentUser?.data?.fullName}");
  }
}

final userConnectionControllerProvider = ChangeNotifierProvider((ref) {
  final userUseCase = ref.watch(userUseCaseProvider);
  final userConnectionUseCase = ref.watch(userConnectionUseCaseProvider);
  final anotherUserController = ref.watch(anotherUserControllerProvider);
  return UserConnectionController(
      userConnectionUseCase, ref, userUseCase, anotherUserController);
});
