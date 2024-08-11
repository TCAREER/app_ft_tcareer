import 'package:app_tcareer/src/routes/index_route.dart';
import 'package:app_tcareer/src/shared/configs/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
        'route': "/${RouteNames.home.name}"
      },
      {
        'icon': PhosphorIconsThin.network,
        'activeIcon': PhosphorIconsFill.network,
        'route': "/${RouteNames.posting.name}"
      },
      {
        'icon': PhosphorIconsThin.plus,
        'activeIcon': PhosphorIconsFill.plus,
        'route': "/${RouteNames.create.name}"
      },
      {
        'icon': PhosphorIconsThin.chatCentered,
        'activeIcon': PhosphorIconsFill.chatCentered,
        'route': "/${RouteNames.message.name}"
      },
      {
        'icon': PhosphorIconsThin.userCircle,
        'activeIcon': PhosphorIconsFill.userCircle,
        'route': "/${RouteNames.profile.name}"
      },
    ];
    return Scaffold(
      body: shell,
      bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: AppColors.primary,
          unselectedItemColor: Colors.grey,
          unselectedLabelStyle: TextStyle(fontSize: 0),
          onTap: (index) {
            shell.goBranch(index);
          },
          currentIndex: shell.currentIndex,
          items: items.map((item) {
            return BottomNavigationBarItem(
                icon: PhosphorIcon(item['icon']),
                activeIcon: PhosphorIcon(item['activeIcon']),
                label: "");
          }).toList()),
    );
  }
}
