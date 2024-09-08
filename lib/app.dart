import 'package:app_tcareer/src/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'src/configs/app_colors.dart';

class App extends StatelessWidget {
  const App({super.key, required this.navigatorKey});
  final GlobalKey<NavigatorState> navigatorKey;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final router = AppRouter.router(ref);
        return ScreenUtilInit(
          designSize: const Size(360, 690),
          minTextAdapt: true,
          builder: (context, child) {
            ScreenUtil.init(context);
            return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              key: navigatorKey,
              routerConfig: router,
              title: 'TCareer',
              theme: ThemeData(
                inputDecorationTheme: const InputDecorationTheme(
                    hintStyle: TextStyle(color: Colors.black45, fontSize: 14)),
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                useMaterial3: true,
                appBarTheme: const AppBarTheme(
                    scrolledUnderElevation: 0.0,
                    backgroundColor: Colors.white,
                    iconTheme: const IconThemeData(color: Colors.black),
                    titleTextStyle: const TextStyle(
                      color: Colors.black,
                    )),
                bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                  type: BottomNavigationBarType.fixed,
                  backgroundColor: Colors.white,
                  selectedLabelStyle: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w400),
                  unselectedLabelStyle: const TextStyle(
                    fontSize: 12,
                  ),
                  selectedItemColor: AppColors.primary,
                  unselectedItemColor: Colors.grey,
                  // showUnselectedLabels: true,
                ),
                textSelectionTheme: const TextSelectionThemeData(
                    cursorColor: AppColors.primary),
              ),
            );
          },
        );
      },
    );
  }
}
