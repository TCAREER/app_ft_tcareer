import 'package:app_tcareer/src/features/authentication/data/repositories/auth_repository.dart';
import 'package:app_tcareer/src/features/authentication/presentation/pages/forgot_password/forgot_password_page.dart';
import 'package:app_tcareer/src/features/authentication/presentation/pages/forgot_password/reset_password_page.dart';
import 'package:app_tcareer/src/features/authentication/presentation/pages/login/login_page.dart';
import 'package:app_tcareer/src/features/authentication/presentation/pages/register/register_page.dart';
import 'package:app_tcareer/src/features/authentication/presentation/pages/verify/verify_page.dart';
import 'package:app_tcareer/src/features/posts/presentation/pages/media/media_page.dart';
import 'package:app_tcareer/src/features/posts/presentation/pages/posting_page.dart';
import 'package:app_tcareer/src/features/posts/presentation/pages/search_page.dart';
import 'package:app_tcareer/src/features/splash/intro_page.dart';
import 'package:app_tcareer/src/features/splash/splash_page.dart';
import 'package:app_tcareer/src/features/user/presentation/pages/another_profile_page.dart';
import 'package:app_tcareer/src/routes/index_route.dart';
import 'package:app_tcareer/src/routes/transition_builder.dart';
import 'package:app_tcareer/src/services/apis/api_service_provider.dart';

import 'package:app_tcareer/src/utils/user_utils.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/posts/presentation/pages/search_page.dart';

enum RouteNames {
  splash,
  intro,
  register,
  login,
  forgotPassword,
  verify,
  resetPassword,
  posting,
  photoManager
}

class AppRouter {
  static final navigatorKey = GlobalKey<NavigatorState>();

  static GoRouter router(WidgetRef ref) {
    final refreshTokenProvider = ref.watch(refreshTokenStateProvider);
    return GoRouter(
        debugLogDiagnostics: true,
        navigatorKey: navigatorKey,
        initialLocation: "/home",
        redirect: (context, state) async {
          final userUtils = ref.watch(userUtilsProvider);
          final isAuthenticated = await userUtils.isAuthenticated();
          final Map<String, String> routeRedirectMap = {
            '/register': '/register',
            '/forgotPassword': '/forgotPassword',
            '/forgotPassword/verify': '/forgotPassword/verify',
            '/forgotPassword/resetPassword': '/forgotPassword/resetPassword',
            '/login': '/login',
            '/intro': '/intro',
          };

          if (isAuthenticated != true ||
              refreshTokenProvider.isRefreshTokenExpired == true) {
            if (routeRedirectMap.containsKey(state.fullPath)) {
              return routeRedirectMap[state.fullPath];
            }
            return "/intro";
          }
          return null;
        },
        routes: [
          Index.router,
          GoRoute(
            path: "/${RouteNames.splash.name}",
            name: RouteNames.splash.name,
            pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: const SplashPage(),
                transitionsBuilder: fadeTransitionBuilder),
          ),
          GoRoute(
            path: "/${RouteNames.intro.name}",
            name: RouteNames.intro.name,
            pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: const IntroPage(),
                transitionsBuilder: fadeTransitionBuilder),
          ),
          GoRoute(
            path: "/${RouteNames.login.name}",
            name: RouteNames.login.name,
            pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: const LoginPage(),
                transitionsBuilder: fadeTransitionBuilder),
          ),
          GoRoute(
            path: "/${RouteNames.register.name}",
            name: RouteNames.register.name,
            pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: const RegisterPage(),
                transitionsBuilder: fadeTransitionBuilder),
          ),
          GoRoute(
              path: "/${RouteNames.forgotPassword.name}",
              name: RouteNames.forgotPassword.name,
              pageBuilder: (context, state) => CustomTransitionPage(
                  key: state.pageKey,
                  child: const ForgotPasswordPage(),
                  transitionsBuilder: fadeTransitionBuilder),
              routes: [
                GoRoute(
                    path: RouteNames.verify.name,
                    name: RouteNames.verify.name,
                    pageBuilder: (context, state) => CustomTransitionPage(
                        key: state.pageKey,
                        child: const VerifyPage(),
                        transitionsBuilder: fadeTransitionBuilder),
                    routes: []),
                GoRoute(
                    path: RouteNames.resetPassword.name,
                    name: RouteNames.resetPassword.name,
                    pageBuilder: (context, state) => CustomTransitionPage(
                        key: state.pageKey,
                        child: const ResetPasswordPage(),
                        transitionsBuilder: fadeTransitionBuilder),
                    routes: []),
              ]),
          GoRoute(
            path: "/${RouteNames.posting.name}",
            name: RouteNames.posting.name,
            pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: const PostingPage(),
                transitionsBuilder: slideUpTransitionBuilder),
          ),
          GoRoute(
            path: "/${RouteNames.photoManager.name}",
            name: RouteNames.photoManager.name,
            pageBuilder: (context, state) {
              String isCommentString =
                  state.uri.queryParameters["isComment"] ?? "false";
              bool isComment = bool.parse(isCommentString);
              return CustomTransitionPage(
                  key: state.pageKey,
                  child: MediaPage(
                    isComment: isComment,
                  ),
                  transitionsBuilder: slideUpTransitionBuilder);
            },
          ),
        ],
        refreshListenable: GoRouterRefreshStream());
  }
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream() {
    // Không cần truyền tham số
  }

  @override
  void notifyListeners() {
    super.notifyListeners();
  }
}
