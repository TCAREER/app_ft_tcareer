import 'package:app_tcareer/src/features/user/data/models/user_data.dart';
import 'package:app_tcareer/src/services/apis/api_service_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserRepository {
  final Ref ref;
  UserRepository(this.ref);

  Future<UserData> getUserInfo() async {
    final api = ref.watch(apiServiceProvider);
    return await api.getUserInfo();
  }
  Future<UserData>getUserById(String userId)async{
    final api = ref.watch(apiServiceProvider);
    return await api.getUserById(userId: userId);
  }
}

final userRepositoryProvider = Provider((ref) => UserRepository(ref));
