import 'package:app_tcareer/src/modules/index/index_page.dart';
import 'package:app_tcareer/src/modules/messages/presentation/pages/message_page.dart';
import 'package:app_tcareer/src/modules/posts/presentation/pages/home_page.dart';
import 'package:app_tcareer/src/modules/posts/presentation/pages/posting_page.dart';
import 'package:app_tcareer/src/modules/profile/presentation/pages/profile_page.dart';
import 'package:app_tcareer/src/routes/home_route.dart';
import 'package:app_tcareer/src/routes/transition_builder.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

enum RouteNames { home, jobs, temp, messages, profile }

class Index {
  static final StatefulShellRoute router = StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          IndexPage(shell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
                path: "/${RouteNames.home.name}",
                name: RouteNames.home.name,
                pageBuilder: (context, state) => CustomTransitionPage(
                    key: state.pageKey,
                    child: const HomePage(),
                    transitionsBuilder: fadeTransitionBuilder),
                routes: HomeRoute.routes),
          ],
        ),
        StatefulShellBranch(routes: [
          GoRoute(
            path: "/${RouteNames.jobs.name}",
            name: RouteNames.jobs.name,
            pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: const Text("Jobs"),
                transitionsBuilder: fadeTransitionBuilder),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: "/${RouteNames.temp.name}",
            name: RouteNames.temp.name,
            pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: const Text("Temp"),
                transitionsBuilder: fadeTransitionBuilder),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: "/${RouteNames.messages.name}",
            name: RouteNames.messages.name,
            pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: const MessagePage(),
                transitionsBuilder: fadeTransitionBuilder),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: "/${RouteNames.profile.name}",
            name: RouteNames.profile.name,
            pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: const ProfilePage(),
                transitionsBuilder: fadeTransitionBuilder),
          ),
        ])
      ]);
}
