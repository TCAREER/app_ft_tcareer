import 'package:app_tcareer/src/features/authentication/presentation/pages/login/login_page.dart';
import 'package:app_tcareer/src/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final router = AppRouter.router(ref);
        return MaterialApp.router(
          routerConfig: router,
          title: 'TCareer',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
        );
      },
    );
  }
}
