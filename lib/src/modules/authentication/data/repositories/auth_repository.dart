import 'package:app_tcareer/src/modules/authentication/data/models/login_request.dart';
import 'package:app_tcareer/src/modules/authentication/data/models/login_response.dart';
import 'package:app_tcareer/src/modules/authentication/data/models/register_request.dart';
import 'package:app_tcareer/src/modules/authentication/presentation/controller/login_controller.dart';
import 'package:app_tcareer/src/modules/authentication/presentation/providers.dart';
import 'package:app_tcareer/src/services/api_services.dart';
import 'package:app_tcareer/src/shared/utils/user_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthRepository {
  final Ref ref;
  AuthRepository(this.ref);

  Future<void> register(RegisterRequest body) async {
    final apiServices = ref.watch(apiServiceProvider);
    await apiServices.postRegister(body: body);
  }

  Future login(LoginRequest body) async {
    try {
      final apiServices = ref.watch(apiServiceProvider);
      final response = await apiServices.postLogin(body: body);
      final userUtil = ref.watch(userUtilsProvider);
      userUtil.saveAuthToken(authToken: response.accessToken ?? "");

      // ref.read(isAuthenticatedProvider.notifier).update((state) => true);
    } catch (e) {
      throw Exception(e);
    }
  }
}

final authRepository = Provider((ref) => AuthRepository(ref));
