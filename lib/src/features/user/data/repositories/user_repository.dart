import 'package:app_tcareer/src/features/user/data/models/users.dart';
import 'package:app_tcareer/src/services/apis/api_service_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserRepository {
  final Ref ref;
  UserRepository(this.ref);

  Future<Users> getUserInfo() async {
    final api = ref.watch(apiServiceProvider);
    return await api.getUserInfo();
  }

  Future<Users> getUserById(String userId) async {
    final api = ref.watch(apiServiceProvider);
    return await api.getUserById(userId: userId);
  }

  Future<void> postFollow(String userId) async {
    final api = ref.watch(apiServiceProvider);
    return await api.postFollow(userId: userId);
  }

  Future<void> postAddFriend(String userId) async {
    final api = ref.watch(apiServiceProvider);
    return await api.postAddFriend(userId: userId);
  }

  Future<void> postAcceptFriend(String userId) async {
    final api = ref.watch(apiServiceProvider);
    return await api.postAcceptFriend(userId: userId);
  }

  Future<void> postDeclineFriend(String userId) async {
    final api = ref.watch(apiServiceProvider);
    return await api.postDeclineFriend(userId: userId);
  }
}

final userRepositoryProvider = Provider((ref) => UserRepository(ref));
