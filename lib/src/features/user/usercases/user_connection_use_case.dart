import 'package:app_tcareer/src/features/user/data/models/users.dart';
import 'package:app_tcareer/src/features/user/data/repositories/user_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserConnectionUseCase {
  final UserRepository userRepository;
  UserConnectionUseCase(this.userRepository);
  Future<Users> postFollow(
      {required String userId, required Users user}) async {
    final updatedUser = setFollowed(user);
    userRepository.postFollow(userId);
    return updatedUser;
  }

  Users setFollowed(Users user) {
    // Cập nhật thuộc tính `followed` và trả về đối tượng đã được cập nhật
    final currentUser = user.data;
    if (currentUser != null) {
      final updatedUserData =
          currentUser.copyWith(followed: !(currentUser.followed ?? false));
      user = user.copyWith(data: updatedUserData);
    }
    return user;
  }

  Future<void> postAddFriend({required String userId}) async {
    // final updateUser = updatedFriendStatus(user, "send_request");
    await userRepository.postAddFriend(userId);
    // return updateUser;
  }

  Future<void> postAcceptFriend({required String userId}) async {
    await userRepository.postAcceptFriend(userId);
  }

  Users updatedFriendStatus(Users user, String status) {
    final currentUser = user.data;
    if (currentUser != null) {
      final updatedUserData = currentUser.copyWith(friendStatus: status);
      user = user.copyWith(data: updatedUserData);
    }
    return user;
  }

  Future<void> postDeclineFriend(String userId) async =>
      await userRepository.postDeclineFriend(userId);

  Future getFollowers(String userId) async =>
      await userRepository.getFollower(userId);
}

final userUseCaseProvider =
    Provider((ref) => UserConnectionUseCase(ref.watch(userRepositoryProvider)));
