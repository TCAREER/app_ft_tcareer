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

  Future<void> postAddFriend(String userId) async =>
      await userRepository.postAddFriend(userId);

  Future<void> postAcceptFriend(String userId) async =>
      await userRepository.postAcceptFriend(userId);

  Future<void> postDeclineFriend(String userId) async =>
      await userRepository.postDeclineFriend(userId);
}

final userUseCaseProvider =
    Provider((ref) => UserConnectionUseCase(ref.watch(userRepositoryProvider)));
