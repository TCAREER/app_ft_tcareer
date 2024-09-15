import 'package:app_tcareer/src/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:flutter/foundation.dart'; // Import kIsWeb
import 'src/configs/app_colors.dart';
import 'package:universal_io/io.dart';

class App extends StatelessWidget {
  const App({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final router = AppRouter.router(ref);
        final navigatorKey = ref.watch(navigatorKeyProvider);
        return ScreenUtilInit(
          designSize: const Size(360, 690),
          minTextAdapt: true,
          builder: (context, child) {
            ScreenUtil.init(context);

            // Kiểm tra nếu ứng dụng đang chạy trên Web
            if (Platform.isAndroid || Platform.isIOS) {
              return OverlaySupport.global(
                child: MaterialApp.router(
                  debugShowCheckedModeBanner: false,
                  key: navigatorKey,
                  routerConfig: router,
                  title: 'TCareer',
                  theme: ThemeData(
                    progressIndicatorTheme:
                        ProgressIndicatorThemeData(color: AppColors.primary),
                    indicatorColor: AppColors.primary,
                    inputDecorationTheme: const InputDecorationTheme(
                        hintStyle:
                            TextStyle(color: Colors.black45, fontSize: 14)),
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
                      type: BottomNavigationBarType.fixed,
                      backgroundColor: Colors.white,
                      selectedLabelStyle:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                      unselectedLabelStyle: TextStyle(
                        fontSize: 12,
                      ),
                      selectedItemColor: AppColors.primary,
                      unselectedItemColor: Colors.grey,
                    ),
                    textSelectionTheme: const TextSelectionThemeData(
                        cursorColor: AppColors.primary),
                  ),
                ),
              );
            }
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: const UnsupportedPlatformPage(), // Trang thông báo
            );
          },
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

final navigatorKeyProvider = Provider<GlobalKey<NavigatorState>>((ref) {
  return GlobalKey<NavigatorState>();
});
