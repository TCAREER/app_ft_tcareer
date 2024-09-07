import 'package:app_tcareer/src/modules/posts/presentation/pages/post_detail_page.dart';
import 'package:app_tcareer/src/routes/transition_builder.dart';
import 'package:go_router/go_router.dart';

class HomeRoute {
  static final List<RouteBase> routes = [
    GoRoute(
      path: "detail/:slug",
      name: "detail",
      pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const PostDetailPage(),
          transitionsBuilder: fadeTransitionBuilder),
    )
  ];
}
