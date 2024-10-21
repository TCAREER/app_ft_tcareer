import 'package:app_tcareer/src/features/user/usercases/connection_use_case.dart';
import 'package:app_tcareer/src/routes/app_router.dart';
import 'package:app_tcareer/src/utils/user_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:overlay_support/overlay_support.dart';
import 'src/configs/app_colors.dart';
import 'package:universal_io/io.dart';

class App extends ConsumerStatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  const App({
    required this.navigatorKey,
    Key? key,
  }) : super(
          key: key,
        );

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> with WidgetsBindingObserver {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    Future.microtask(() async {
      final appLifecycleNotifier = ref.read(appLifecycleProvider.notifier);
      await appLifecycleNotifier.updateState(state, ref, context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        Future.microtask(() async {
          final connectionUseCase = ref.watch(connectionUseCaseProvider);
          await connectionUseCase.monitorConnection();
        });
        final router = AppRouter.router(ref, widget.navigatorKey);

        return ScreenUtilInit(
            designSize: const Size(360, 690),
            minTextAdapt: true,
            builder: (context, child) {
              ScreenUtil.init(context);

              // Kiểm tra nếu ứng dụng đang chạy trên Web
              // if (Platform.isAndroid || Platform.isIOS) {
              return OverlaySupport.global(
                child: MaterialApp.router(
                  routerConfig: router,
                  debugShowCheckedModeBanner: false,
                  title: 'TCareer',
                  theme: ThemeData(
                    progressIndicatorTheme:
                        ProgressIndicatorThemeData(color: AppColors.primary),
                    indicatorColor: AppColors.primary,
                    inputDecorationTheme: const InputDecorationTheme(
                        hintStyle:
                            TextStyle(color: Colors.black45, fontSize: 12)),
                    colorScheme:
                        ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                    useMaterial3: true,
                    appBarTheme: const AppBarTheme(
                        scrolledUnderElevation: 0.0,
                        backgroundColor: Colors.white,
                        iconTheme: IconThemeData(color: Colors.black),
                        titleTextStyle: TextStyle(
                          color: Colors.black,
                        )),
                    bottomNavigationBarTheme:
                        const BottomNavigationBarThemeData(
                      landscapeLayout:
                          BottomNavigationBarLandscapeLayout.centered,
                      type: BottomNavigationBarType.fixed,
                      backgroundColor: Colors.white,
                      selectedLabelStyle:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                      unselectedLabelStyle: TextStyle(
                        fontSize: 12,
                      ),
                      selectedItemColor: Colors.black,
                      unselectedItemColor: Colors.black,
                    ),
                    textSelectionTheme: const TextSelectionThemeData(
                        cursorColor: AppColors.primary),
                  ),
                ),
              );
            }
            //   return MaterialApp(
            //     debugShowCheckedModeBanner: false,
            //     home: const UnsupportedPlatformPage(), // Trang thông báo
            //   );
            // },
            );
      },
    );
  }
}

class UnsupportedPlatformPage extends StatelessWidget {
  const UnsupportedPlatformPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.warning, size: 50, color: Colors.red),
            SizedBox(height: 20),
            Text(
              'Ứng dụng chỉ hỗ trợ trên thiết bị di động',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class AppLifecycleNotifier extends StateNotifier<AppLifecycleState> {
  AppLifecycleNotifier() : super(AppLifecycleState.resumed);

  Future<void> updateState(
      AppLifecycleState state, WidgetRef ref, BuildContext context) async {
    this.state = state; // Cập nhật trạng thái
    final connectionUseCase = ref.read(connectionUseCaseProvider);
    final userUtil = ref.watch(userUtilsProvider);
    bool isAuthenticated = await userUtil.isAuthenticated();
    if (!isAuthenticated) return;
    if (state == AppLifecycleState.paused) {
      // Thực hiện các hành động cần thiết khi app ở nền
      // Ví dụ: Gọi một provider khác
      if (isAuthenticated) {
        await Future.delayed(Duration(minutes: 1));
        await connectionUseCase.setUserOfflineStatus();
      }
    } else if (state == AppLifecycleState.resumed) {
      final state = GoRouterState.of(context);
      bool isChatRoute = state.fullPath?.contains("conversation") == true ||
          state.fullPath?.contains("chat") == true;
      print(">>>>>>>>>>isChatRoute: $isChatRoute");
      if (isChatRoute) {
        await connectionUseCase.setUserOnlineStatusInMessage();
      } else {
        await connectionUseCase.setUserOnlineStatus();
      }
    }
  }
}

// Tạo provider cho AppLifecycleNotifier
final appLifecycleProvider =
    StateNotifierProvider<AppLifecycleNotifier, AppLifecycleState>((ref) {
  return AppLifecycleNotifier();
});
