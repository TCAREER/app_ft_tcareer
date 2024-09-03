import 'package:app_tcareer/src/routes/index_route.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class IndexPage extends StatelessWidget {
  const IndexPage({super.key, required this.shell});
  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> items = [
      {
        'icon': PhosphorIconsThin.house,
        'activeIcon': PhosphorIconsFill.house,
        'route': "/${RouteNames.home.name}",
        "label": "Trang chủ"
      },
      {
        'icon': PhosphorIconsThin.bagSimple,
        'activeIcon': PhosphorIconsFill.bagSimple,
        'route': "/${RouteNames.posting.name}",
        "label": "Công việc"
      },
      {
        'icon': PhosphorIconsFill.plus,
        'activeIcon': PhosphorIconsFill.plus,
        'route': "/${RouteNames.create.name}",
        "label": "Tạo mới"
      },
      {
        'icon': PhosphorIconsThin.bell,
        'activeIcon': PhosphorIconsFill.bell,
        'route': "/${RouteNames.message.name}",
        "label": "Thông báo"
      },
      {
        'icon': PhosphorIconsThin.userCircle,
        'activeIcon': PhosphorIconsFill.userCircle,
        'route': "/${RouteNames.profile.name}",
        "label": "Tài khoản"
      },
    ];
    return Scaffold(
      body: shell,
      bottomNavigationBar: BottomNavigationBar(
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
    );
  }
}
