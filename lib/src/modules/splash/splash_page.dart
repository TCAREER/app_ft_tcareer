import 'package:app_tcareer/src/routes/app_router.dart';
import 'package:app_tcareer/src/shared/configs/app_colors.dart';
import 'package:app_tcareer/src/shared/utils/user_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();

    final userUtils = ref.read(userUtilsProvider);

    Future.delayed(Duration(seconds: 1), () async {
      if (!mounted)
        return; // Kiểm tra xem widget có còn trong cây widget hay không
      final isAuthenticated = await userUtils.isAuthenticated();
      if (isAuthenticated != true) {
        context.go("/intro");
      } else {
        context.go("/home");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
