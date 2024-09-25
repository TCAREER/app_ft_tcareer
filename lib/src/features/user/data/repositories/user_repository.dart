import 'package:app_tcareer/src/features/user/data/models/user_data.dart';
import 'package:app_tcareer/src/services/apis/api_service_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserRepository {
  final Ref ref;
  UserRepository(this.ref);

  Future<UserData> getUserInfo() async {
    final api = ref.watch(apiServiceProvider);
    return api.getUserInfo();
  }
}

final userRepositoryProvider = Provider((ref) => UserRepository(ref));
