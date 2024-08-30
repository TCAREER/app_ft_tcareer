import 'package:app_tcareer/src/modules/add_post/presentation/pages/add_post_page.dart';
import 'package:app_tcareer/src/modules/home/presentation/pages/home_page.dart';
import 'package:app_tcareer/src/modules/index/index_page.dart';
import 'package:app_tcareer/src/modules/messages/presentation/pages/message_page.dart';
import 'package:app_tcareer/src/modules/profile/presentation/pages/profile_page.dart';
import 'package:app_tcareer/src/routes/transition_builder.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

enum RouteNames { home, posting, create, message, profile }

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
            ),
          ],
        ),
        StatefulShellBranch(routes: [
          GoRoute(
            path: "/${RouteNames.posting}",
            name: RouteNames.posting.name,
            pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: const AddPostPage(),
                transitionsBuilder: fadeTransitionBuilder),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: "/${RouteNames.create.name}",
            name: RouteNames.create.name,
            pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: Text("create"),
                transitionsBuilder: fadeTransitionBuilder),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: "/${RouteNames.message.name}",
            name: RouteNames.message.name,
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
