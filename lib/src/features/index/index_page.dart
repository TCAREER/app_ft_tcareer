import 'package:app_tcareer/src/configs/app_colors.dart';
import 'package:app_tcareer/src/features/index/index_controller.dart';
import 'package:app_tcareer/src/features/notifications/presentation/controllers/notification_controller.dart';
import 'package:app_tcareer/src/features/posts/presentation/posts_provider.dart';
import 'package:app_tcareer/src/routes/index_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:badges/badges.dart' as badges;

class IndexPage extends ConsumerWidget {
  const IndexPage({super.key, required this.shell});
  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Map<String, dynamic>> items = [
      {
        'icon': PhosphorIconsThin.house,
        'activeIcon': PhosphorIconsFill.house,
        'route': 'home',
        "label": "Trang chủ"
      },
      {
        'icon': PhosphorIconsThin.bagSimple,
        'activeIcon': PhosphorIconsFill.bagSimple,
        'route': 'jobs',
        "label": "Công việc"
      },
      {
        'icon': PhosphorIconsThin.plusSquare,
        'activeIcon': PhosphorIconsThin.plusSquare,
        'route': 'posting',
        "label": "Tạo mới"
      },
      {
        'icon': PhosphorIconsThin.bell,
        'activeIcon': PhosphorIconsThin.bell,
        'route': 'nofications',
        "label": "Thông báo"
      },
      {
        'icon': PhosphorIconsThin.userCircle,
        'activeIcon': PhosphorIconsFill.userCircle,
        'route': 'user',
        "label": "Tài khoản"
      },
    ];
    final state = ref.watch(indexControllerProvider);
    final postController = ref.watch(postControllerProvider);

    return Scaffold(
      body: shell,
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: Visibility(
      //   visible: state == true,
      //   child: Padding(
      //     padding: const EdgeInsets.only(top: 30, right: 20, left: 20),
      //     child: Padding(
      //       padding: const EdgeInsets.all(5),
      //       child: FloatingActionButton(
      //           shape: const CircleBorder(),
      //           backgroundColor: AppColors.primary,
      //           isExtended: true,
      //           onPressed: () => context.pushNamed("posting"),
      //           child: const Icon(
      //             Icons.add,
      //             color: Colors.white,
      //             size: 35,
      //           )),
      //     ),
      //   ),
      // ),
      bottomNavigationBar: Visibility(
        visible: state == true,
        child: BottomNavigationBar(
            showSelectedLabels: false,
            showUnselectedLabels: false,
            // selectedItemColor: Colors.black,
            // unselectedItemColor: Colors.grey,
            // unselectedLabelStyle: TextStyle(fontSize: 10),
            // selectedLabelStyle: TextStyle(fontSize: 10),
            onTap: (index) {
              if (index != 2) {
                if (index == shell.currentIndex) {
                  final GoRouter router = GoRouter.of(context);
                  String currentRoute =
                      router.routeInformationProvider.value.uri.toString();
                  String route = items[index]['route'];
                  print(">>>>>>>>>>>>>>>>A");
                  context.goNamed(route, extra: "reload");
                } else {
                  shell.goBranch(index);
                }
              } else {
                context.pushNamed("posting");
              }
            },
            currentIndex: shell.currentIndex,
            items: items.asMap().entries.map((entry) {
              final item = entry.value;
              final index = entry.key;
              return BottomNavigationBarItem(
                  icon: Visibility(
                      visible: index != 3,
                      replacement: notificationIcon(ref),
                      child: PhosphorIcon(item['icon'])),
                  activeIcon: Visibility(
                      visible: index != 3,
                      replacement: notificationIcon(ref, active: true),
                      child: PhosphorIcon(item['activeIcon'])),
                  label: item['label']);
            }).toList()),
      ),
    );
  }

  Widget notificationIcon(WidgetRef ref, {bool active = false}) {
    final notificationController = ref.watch(notificationControllerProvider);
    return StreamBuilder<List<Map<String, dynamic>>>(
        stream: notificationController.notificationsStream(),
        builder: (context, snapshot) {
          return badges.Badge(
            position: badges.BadgePosition.topEnd(top: -10, end: -8),
            showBadge: true,
            ignorePointer: false,
            badgeContent: Text(
              snapshot.data?.length.toString() ?? "",
              style: const TextStyle(color: Colors.white),
            ),
            badgeStyle: const badges.BadgeStyle(badgeColor: Colors.blue),
            child: Visibility(
              visible: active != true,
              replacement: PhosphorIcon(
                PhosphorIconsFill.bell,
              ),
              child: PhosphorIcon(
                PhosphorIconsThin.bell,
              ),
            ),
          );
        });
  }
}
