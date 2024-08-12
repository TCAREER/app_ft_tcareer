import 'package:app_tcareer/src/routes/app_router.dart';
import 'package:app_tcareer/src/shared/configs/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class App extends StatelessWidget {
  const App({super.key, required this.navigatorKey});
  final GlobalKey<NavigatorState> navigatorKey;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final router = AppRouter.router(ref);
        return MaterialApp.router(
          key: navigatorKey,
          routerConfig: router,
          title: 'TCareer',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white,
              selectedLabelStyle:
                  const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
              unselectedLabelStyle:
                  const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
              selectedItemColor: AppColors.primary,
              unselectedItemColor: Colors.grey.shade500,
              // showUnselectedLabels: true,
            ),
            textSelectionTheme:
                const TextSelectionThemeData(cursorColor: AppColors.primary),
          ),
        );
      },
    );
  }
}
