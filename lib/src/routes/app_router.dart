import 'package:app_tcareer/main.dart';
import 'package:app_tcareer/src/features/authentication/data/models/verify_otp.dart';
import 'package:app_tcareer/src/features/authentication/data/repositories/auth_repository.dart';
import 'package:app_tcareer/src/features/authentication/presentation/pages/forgot_password/forgot_password_page.dart';
import 'package:app_tcareer/src/features/authentication/presentation/pages/forgot_password/reset_password_page.dart';
import 'package:app_tcareer/src/features/authentication/presentation/pages/login/login_page.dart';
import 'package:app_tcareer/src/features/authentication/presentation/pages/register/register_page.dart';
import 'package:app_tcareer/src/features/authentication/presentation/pages/register/verify_phone_page.dart';
import 'package:app_tcareer/src/features/authentication/presentation/pages/verify/verify_page.dart';
import 'package:app_tcareer/src/features/chat/presentation/pages/chat_page.dart';
import 'package:app_tcareer/src/features/chat/presentation/pages/conversation_page.dart';
import 'package:app_tcareer/src/features/posts/data/models/create_post_request.dart';
import 'package:app_tcareer/src/features/posts/data/models/post_edit.dart';
import 'package:app_tcareer/src/features/posts/data/models/shared_post.dart';
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

enum RouteNames {
  splash,
  intro,
  register,
  login,
  forgotPassword,
  verify,
  resetPassword,
  posting,
  photoManager,
}

// FutureProvider lưu trữ trạng thái xác thực bất đồng bộ
class AuthStateNotifier extends StateNotifier<bool> {
  final UserUtils
      userUtils; // Sử dụng UserUtils để kiểm tra trạng thái xác thực

  AuthStateNotifier(this.userUtils) : super(false);

  // Hàm để cập nhật trạng thái xác thực
  Future<void> checkAuthentication() async {
    final isAuthenticated = await userUtils.isAuthenticated();
    print(">>>>>>>>>isAuthenticated: $isAuthenticated");
    state = isAuthenticated; // Cập nhật trạng thái
  }
}

final authStateProvider = StateNotifierProvider<AuthStateNotifier, bool>((ref) {
  final userUtils = ref.watch(userUtilsProvider);
  return AuthStateNotifier(userUtils);
});

class AppRouter {
  static GoRouter router(
      WidgetRef ref, GlobalKey<NavigatorState> navigatorKey) {
    return GoRouter(
      navigatorKey: navigatorKey,
      debugLogDiagnostics: true,
      initialLocation: "/home",
      redirect: (context, state) async {
        // Lấy trạng thái xác thực và refresh token
        // ref.read(authStateProvider.notifier).checkAuthentication();
        // final isAuthenticated = ref.watch(authStateProvider);
        final refreshTokenProvider = ref.watch(refreshTokenStateProvider);
        final userUtils = ref.watch(userUtilsProvider);
        final isAuthenticated = await userUtils.isAuthenticated();
        final Map<String, String> routeRedirectMap = {
          '/register': '/register',
          '/forgotPassword': '/forgotPassword',
          '/forgotPassword/verify': '/forgotPassword/verify',
          '/forgotPassword/resetPassword': '/forgotPassword/resetPassword',
          '/login': '/login',
          '/intro': '/intro',
          '/verifyPhone': '/verifyPhone'
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
            transitionsBuilder: fadeTransitionBuilder,
          ),
        ),
        GoRoute(
          path: "/${RouteNames.intro.name}",
          name: RouteNames.intro.name,
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const IntroPage(),
            transitionsBuilder: cupertinoTransitionBuilder,
          ),
        ),
        GoRoute(
          path: "/${RouteNames.login.name}",
          name: RouteNames.login.name,
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const LoginPage(),
            transitionsBuilder: fadeTransitionBuilder,
          ),
        ),
        GoRoute(
          path: "/verifyPhone",
          name: "verifyPhone",
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const VerifyPhonePage(),
            transitionsBuilder: fadeTransitionBuilder,
          ),
        ),
        GoRoute(
          path: "/${RouteNames.register.name}",
          name: RouteNames.register.name,
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const RegisterPage(),
            transitionsBuilder: fadeTransitionBuilder,
          ),
        ),
        GoRoute(
          path: "/${RouteNames.forgotPassword.name}",
          name: RouteNames.forgotPassword.name,
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const ForgotPasswordPage(),
            transitionsBuilder: fadeTransitionBuilder,
          ),
          routes: [
            GoRoute(
                path: RouteNames.verify.name,
                name: RouteNames.verify.name,
                pageBuilder: (context, state) {
                  VerifyOTP? verifyOTp = state.extra as VerifyOTP?;
                  return CustomTransitionPage(
                    key: state.pageKey,
                    child: VerifyPage(
                      verifyOTP: verifyOTp,
                    ),
                    transitionsBuilder: fadeTransitionBuilder,
                  );
                }),
            GoRoute(
              path: RouteNames.resetPassword.name,
              name: RouteNames.resetPassword.name,
              pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: const ResetPasswordPage(),
                transitionsBuilder: fadeTransitionBuilder,
              ),
            ),
          ],
        ),
        GoRoute(
            path: "/${RouteNames.posting.name}",
            name: RouteNames.posting.name,
            pageBuilder: (context, state) {
              PostEdit? postEdit = state.extra as PostEdit?;
              String? postId = state.uri.queryParameters['postId'].toString();
              String? action = state.uri.queryParameters['action'].toString();
              return CustomTransitionPage(
                key: state.pageKey,
                child: PostingPage(
                  postEdit: postEdit,
                  postId: postId,
                  action: action,
                ),
                transitionsBuilder: slideUpTransitionBuilder,
              );
            },
            routes: [
              GoRoute(
                path: "${RouteNames.photoManager.name}",
                name: RouteNames.photoManager.name,
                pageBuilder: (context, state) {
                  String isCommentString =
                      state.uri.queryParameters["isComment"] ?? "false";
                  String content = state.uri.queryParameters['content'] ?? "";
                  bool isComment = bool.parse(isCommentString);
                  return CustomTransitionPage(
                    key: state.pageKey,
                    child: MediaPage(
                      isComment: isComment,
                      content: content,
                    ),
                    transitionsBuilder: slideUpTransitionBuilder,
                  );
                },
              ),
            ]),
        GoRoute(
            path: "/conversation",
            name: "conversation",
            pageBuilder: (context, state) {
              return const CustomTransitionPage(
                  child: ConversationPage(),
                  transitionsBuilder: fadeTransitionBuilder);
            },
            routes: [
              GoRoute(
                  path: "chat/:userId/:clientId",
                  name: "chat",
                  pageBuilder: (context, state) {
                    String userId = state.pathParameters['userId'].toString();
                    String clientId =
                        state.pathParameters['clientId'].toString();
                    return CustomTransitionPage(
                        child: ChatPage(
                          userId: userId,
                          clientId: clientId,
                        ),
                        transitionsBuilder: fadeTransitionBuilder);
                  },
                  routes: [])
            ])
      ],
      refreshListenable: GoRouterRefreshStream(),
    );
  }
}

class GoRouterRefreshStream extends ChangeNotifier {
  @override
  void notifyListeners() {
    super.notifyListeners();
  }
}
