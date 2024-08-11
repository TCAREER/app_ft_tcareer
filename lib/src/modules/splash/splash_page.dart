import 'package:app_tcareer/src/routes/app_router.dart';
import 'package:app_tcareer/src/shared/configs/app_colors.dart';
import 'package:app_tcareer/src/shared/utils/user_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class SplashPage extends ConsumerWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userUtils = ref.watch(userUtilsProvider);

    Future.delayed(Duration(seconds: 1), () async {
      print(">>>>>>>>>>${await userUtils.isAuthenticated()}");
      if (await userUtils.isAuthenticated() != true) {
        context.go("/intro");
      } else {
        context.go("/home");
      }
    });
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset("assets/images/splash/splash.svg"),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "TCareer",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
