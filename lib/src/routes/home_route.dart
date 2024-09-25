import 'package:app_tcareer/src/features/posts/data/models/photo_view_data.dart';
import 'package:app_tcareer/src/features/posts/presentation/pages/detail/photo_view_gallery_page.dart';
import 'package:app_tcareer/src/features/posts/presentation/pages/detail/post_detail_page.dart';
import 'package:app_tcareer/src/features/posts/presentation/pages/search_page.dart';
import 'package:app_tcareer/src/routes/transition_builder.dart';
import 'package:go_router/go_router.dart';

class HomeRoute {
  static final List<RouteBase> routes = [
    GoRoute(
      path: "detail/:id",
      name: "detail",
      pageBuilder: (context, state) {
        final postId = state.pathParameters["id"] ?? "";
        return CustomTransitionPage(
            key: state.pageKey,
            child: PostDetailPage(postId),
            transitionsBuilder: fadeTransitionBuilder);
      },
    ),
    GoRoute(
      path: "photoView",
      name: "photoView",
      builder: (context, state) {
        final postId = state.uri.queryParameters['postId'].toString();
        final data = state.extra as PhotoViewData;
        return PhotoViewGalleryPage(data.images, postId, data.onPageChanged);
      },
    ),
    GoRoute(
      path: "search",
      name: "search",
      builder: (context, state) {
        return const SearchPage();
      },
    ),
  ];
}
