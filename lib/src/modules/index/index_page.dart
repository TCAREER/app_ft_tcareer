import 'package:app_tcareer/src/modules/index/index_controller.dart';
import 'package:app_tcareer/src/routes/index_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class IndexPage extends ConsumerWidget {
  const IndexPage({super.key, required this.shell});
  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Map<String, dynamic>> items = [
      {
        'icon': PhosphorIconsThin.house,
        'activeIcon': PhosphorIconsFill.house,
        'route': "/home",
        "label": "Trang chủ"
      },
      {
        'icon': PhosphorIconsThin.bagSimple,
        'activeIcon': PhosphorIconsFill.bagSimple,
        'route': "/jobs",
        "label": "Công việc"
      },
      {
        'icon': PhosphorIconsFill.plus,
        'activeIcon': PhosphorIconsFill.plus,
        'route': "/posting",
        "label": "Tạo mới"
      },
      {
        'icon': PhosphorIconsThin.bell,
        'activeIcon': PhosphorIconsFill.bell,
        'route': "/messages",
        "label": "Thông báo"
      },
      {
        'icon': PhosphorIconsThin.userCircle,
        'activeIcon': PhosphorIconsFill.userCircle,
        'route': "/profile",
        "label": "Tài khoản"
      },
    ];
    final state = ref.watch(indexControllerProvider);

    return Scaffold(
      body: shell,
      bottomNavigationBar: Visibility(
        visible: state == true,
        child: BottomNavigationBar(
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.grey,
            // unselectedLabelStyle: TextStyle(fontSize: 0),
            onTap: (index) {
              shell.goBranch(index);
            },
            currentIndex: shell.currentIndex,
            items: items.map((item) {
              return BottomNavigationBarItem(
                  icon: PhosphorIcon(item['icon']),
                  activeIcon: PhosphorIcon(item['activeIcon']),
                  label: item['label']);
            }).toList()),
      ),
    );
  }
}
