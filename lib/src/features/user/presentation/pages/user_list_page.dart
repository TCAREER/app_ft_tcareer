import 'package:app_tcareer/src/configs/app_colors.dart';
import 'package:app_tcareer/src/features/posts/data/models/user_liked.dart';
import 'package:app_tcareer/src/features/posts/presentation/pages/user_liked_page.dart';
import 'package:app_tcareer/src/features/posts/presentation/posts_provider.dart';
import 'package:app_tcareer/src/features/user/presentation/controllers/user_connection_controller.dart';
import 'package:app_tcareer/src/widgets/circular_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class UserListPage extends ConsumerStatefulWidget {
  final String? userId;

  const UserListPage({this.userId});

  @override
  ConsumerState<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends ConsumerState<UserListPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() {
      ref
          .read(userConnectionControllerProvider)
          .getFollowers(widget.userId ?? "");
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(userConnectionControllerProvider);
    final postController = ref.watch(postControllerProvider);

    final users = controller.followers;
    return ClipRRect(
      borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      child: ListView(
        children: [
          AppBar(
            // toolbarHeight: 30,
            centerTitle: true,
            automaticallyImplyLeading: false,
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(5)),
                  width: 30,
                  height: 4,
                ),
                const SizedBox(height: 10),
                const Text(
                  "Đang theo dõi",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Divider(
            // thickness: 0.1,
            color: Colors.grey.shade200,
          ),
          Visibility(
            visible: controller.followers.isNotEmpty,
            replacement: circularLoadingWidget(),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: users.length ?? 0,
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                    onTap: () => postController.goToProfile(
                        userId: user.id.toString() ?? "", context: context),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(user.avatar ??
                          "https://ui-avatars.com/api/?name=${user.fullName}&background=random"),
                    ),
                    title: Text(user.fullName ?? ""),
                    trailing: Icon(
                      size: 20,
                      Icons.arrow_forward_ios_outlined,
                      color: Colors.black,
                    ));
              },
              separatorBuilder: (context, index) => const SizedBox(
                height: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}