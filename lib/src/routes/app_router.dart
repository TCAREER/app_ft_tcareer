import 'package:app_tcareer/src/modules/authentication/data/repositories/auth_repository.dart';
import 'package:app_tcareer/src/modules/authentication/presentation/pages/login/login_page.dart';
import 'package:app_tcareer/src/modules/authentication/presentation/pages/register/register_page.dart';
import 'package:app_tcareer/src/modules/authentication/presentation/providers.dart';
import 'package:app_tcareer/src/modules/home/presentation/pages/home_page.dart';
import 'package:app_tcareer/src/modules/splash/intro_page.dart';
import 'package:app_tcareer/src/modules/splash/splash_page.dart';
import 'package:app_tcareer/src/routes/index_route.dart';
import 'package:app_tcareer/src/routes/transition_builder.dart';
import 'package:app_tcareer/src/shared/utils/user_utils.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

enum RouteNames { splash, intro, register, login }

class AppRouter {
  static final navigatorKey = GlobalKey<NavigatorState>();

  static GoRouter router(WidgetRef ref) {
    return GoRouter(
        navigatorKey: navigatorKey,
        initialLocation: "/splash",
        // redirect: (context, state) async {
        //   final userUtils = ref.watch(userUtilsProvider);
        //   print(">>>>>>>>>>>${await userUtils.isAuthenticated()}");
        //   final isAuthenticated = ref.watch(isAuthenticatedProvider);
        //   print(">>>>>>>>>>>>>>>>>>$isAuthenticated");
        //   if (isAuthenticated != true ||
        //       await userUtils.isAuthenticated() != true) {
        //     if (state.fullPath?.contains("/intro") == true) {
        //       return "/intro";
        //     }
        //     if (state.fullPath?.contains("/login") == true) {
        //       return "/login";
        //     }
        //     return "/splash";
        //   }

        //   return null;
        // },
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
        ],
        refreshListenable: GoRouterRefreshStream());
  }
}

class GoRouterRefreshStream extends ChangeNotifier {
  @override
  void notifyListeners() {
    super.notifyListeners();
  }
}
