import 'package:app_tcareer/src/utils/user_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userUtils = ref.watch(userUtilsProvider);
    return Scaffold(
      body: ListView(
        children: [
          TextButton(
              onPressed: () => userUtils.logout(context),
              child: Text("Đăng xuất"))
        ],
      ),
    );
  }
}
