import 'package:app_tcareer/src/configs/app_constants.dart';
import 'package:app_tcareer/src/configs/shared_preferences_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class UserUtils {
  final Ref ref;
  UserUtils(this.ref);

  Future<void> saveAuthToken(
      {required String authToken, required String refreshToken}) async {
    final sharedRef = await ref.read(sharedPreferencesProvider.future);
    sharedRef.setString(AppConstants.authToken, authToken);
    sharedRef.setString(AppConstants.refreshToken, refreshToken);
    // ref.read(isAuthenticatedProvider.notifier).update((state) => true);
  }

  Future<bool> isAuthenticated() async {
    final sharedRef = await ref.read(sharedPreferencesProvider.future);
    final authToken = sharedRef.getString(AppConstants.authToken);
    // if (authToken != null) {
    //   ref.read(isAuthenticatedProvider.notifier).update((state) => true);
    // }
    return authToken != null; // Trả về true nếu token tồn tại, false nếu không
  }

  Future<void> logout(BuildContext context) async {
    final sharedRef = await ref.read(sharedPreferencesProvider.future);
    sharedRef.remove(AppConstants.authToken);
    // ref.read(isAuthenticatedProvider.notifier).update((state) => false);
    context.go("/login");
  }

  Future<String> getAuthToken() async {
    final sharedRef = await ref.read(sharedPreferencesProvider.future);
    return sharedRef.getString(AppConstants.authToken) ?? "";
  }

  Future<bool> saveCacheList(
      {required String key, required List<String> value}) async {
    final shareRef = await ref.read(sharedPreferencesProvider.future);
    return shareRef.setStringList(key, value);
  }

  Future<List<String>?> loadCacheList(String key) async {
    final shareRef = await ref.read(sharedPreferencesProvider.future);
    return shareRef.getStringList(key);
  }

  Future<bool> removeCache(String key) async {
    final shareRef = await ref.read(sharedPreferencesProvider.future);
    return shareRef.remove(key);
  }
}

final userUtilsProvider = Provider((ref) => UserUtils(ref));
