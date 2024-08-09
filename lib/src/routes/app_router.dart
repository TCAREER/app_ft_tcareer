import 'package:app_tcareer/src/features/authentication/presentation/pages/login/login_page.dart';
import 'package:app_tcareer/src/features/authentication/presentation/pages/register/register_page.dart';
import 'package:app_tcareer/src/features/authentication/presentation/providers.dart';
import 'package:app_tcareer/src/features/home/home_page.dart';
import 'package:app_tcareer/src/features/splash/intro_page.dart';
import 'package:app_tcareer/src/features/splash/splash_page.dart';
import 'package:app_tcareer/src/routes/transition_builder.dart';
import 'package:app_tcareer/src/shared/utils/user_utils.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

enum RouteNames { splash, intro, register, login, home }

class AppRouter {
  static final navigatorKey = GlobalKey<NavigatorState>();

  static GoRouter router(WidgetRef ref) {
    return GoRouter(
        navigatorKey: navigatorKey,
        initialLocation: "/${RouteNames.splash.name}",
        redirect: (context, state) async {
          // final userUtils = ref.watch(userUtilsProvider);
          // print(">>>>>>>>>>>${await userUtils.isAuthenticated()}");
          final isAuthenticated = ref.watch(isAuthenticatedProvider);
          print(">>>>>>>>>$isAuthenticated");
          if (isAuthenticated) {
            return "/${RouteNames.home.name}";
          }

          return null;
        },
        routes: [
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
            path: "/${RouteNames.home.name}",
            name: RouteNames.home.name,
            pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: const HomePage(),
                transitionsBuilder: fadeTransitionBuilder),
          )
        ]);
  }
}
