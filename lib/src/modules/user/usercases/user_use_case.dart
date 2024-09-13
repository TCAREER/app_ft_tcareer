import 'package:app_tcareer/src/modules/user/data/models/user_data.dart';
import 'package:app_tcareer/src/modules/user/data/repositories/user_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserUseCase {
  final UserRepository userRepository;
  UserUseCase(this.userRepository);

  Future<UserData> getUserInfo() async => await userRepository.getUserInfo();
}

final userUseCaseProvider =
    Provider((ref) => UserUseCase(ref.watch(userRepositoryProvider)));
