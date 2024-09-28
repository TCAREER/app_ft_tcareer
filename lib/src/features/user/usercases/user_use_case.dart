import 'package:app_tcareer/src/features/user/data/models/users.dart';
import 'package:app_tcareer/src/features/user/data/repositories/user_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserUseCase {
  final UserRepository userRepository;
  UserUseCase(this.userRepository);

  Future<Users> getUserInfo() async => await userRepository.getUserInfo();
  Future<Users>getUserById(String userId)async=>await userRepository.getUserById(userId);
}

final userUseCaseProvider =
    Provider((ref) => UserUseCase(ref.watch(userRepositoryProvider)));
