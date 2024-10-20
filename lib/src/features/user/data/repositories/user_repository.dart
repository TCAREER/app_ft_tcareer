import 'package:app_tcareer/src/features/user/data/models/users.dart';
import 'package:app_tcareer/src/services/apis/api_service_provider.dart';
import 'package:app_tcareer/src/services/firebase/firebase_database_service.dart';
import 'package:firebase_database/firebase_database.dart';
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

  Future getFollower(String userId) async {
    final api = ref.watch(apiServiceProvider);
    return await api.getFollowers(userId: userId);
  }

  Future<void> addData(
      {required String path,
      required Map<String, dynamic> data,
      Map<String, Object?>? dataUpdateDisconnect}) async {
    final database = ref.watch(firebaseDatabaseServiceProvider);
    return await database.addData(
        path: path, data: data, dataUpdate: dataUpdateDisconnect);
  }

  Future<void> updateData(
      {required String path, required Map<String, dynamic> data}) async {
    final database = ref.watch(firebaseDatabaseServiceProvider);
    return await database.updateData(path: path, data: data);
  }

  Future<void> monitorConnection(
      void Function(DatabaseEvent event)? onData) async {
    final database = ref.watch(firebaseDatabaseServiceProvider);
    return await database.monitorConnection(onData);
  }
}

final userRepositoryProvider = Provider((ref) => UserRepository(ref));
