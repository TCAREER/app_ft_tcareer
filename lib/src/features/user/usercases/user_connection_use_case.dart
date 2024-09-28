import 'package:app_tcareer/src/features/user/data/models/users.dart';
import 'package:app_tcareer/src/features/user/data/repositories/user_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserConnectionUseCase {
  final UserRepository userRepository;
  UserConnectionUseCase(this.userRepository);
  Future<void>postFollow(String userId)async=>await userRepository.postFollow(userId);

  Future<void>postAddFriend(String userId)async=>await userRepository.postAddFriend(userId);

  Future<void>postAcceptFriend(String userId)async=>await userRepository.postAcceptFriend(userId);

  Future<void>postDeclineFriend(String userId)async=>await userRepository.postDeclineFriend(userId);

}

final userUseCaseProvider =
Provider((ref) => UserConnectionUseCase(ref.watch(userRepositoryProvider)));
