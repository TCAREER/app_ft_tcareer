import 'package:app_tcareer/src/shared/configs/app_constants.dart';
import 'package:app_tcareer/src/shared/configs/shared_preferences_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserUtils {
  final Ref ref;
  UserUtils(this.ref);

  Future<void> saveAuthToken({required String authToken}) async {
    final sharedRef = await ref.read(sharedPreferencesProvider.future);
    sharedRef.setString(AppConstants.authToken, authToken);
  }

  Future<bool> isAuthenticated() async {
    final sharedRef = await ref.read(sharedPreferencesProvider.future);
    final authToken = sharedRef.getString(AppConstants.authToken);
    if (authToken != null) {
      return true;
    }
    return false;
  }
}

final userUtilsProvider = Provider((ref) => UserUtils(ref));
