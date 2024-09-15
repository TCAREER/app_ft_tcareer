import 'package:app_tcareer/src/configs/app_colors.dart';
import 'package:app_tcareer/src/modules/posts/data/models/posts_response.dart';
import 'package:app_tcareer/src/modules/posts/presentation/controllers/post_controller.dart';
import 'package:app_tcareer/src/modules/posts/presentation/posts_provider.dart';
import 'package:app_tcareer/src/modules/posts/presentation/widgets/post_loading_widget.dart';
import 'package:app_tcareer/src/modules/posts/presentation/widgets/post_widget.dart';
import 'package:app_tcareer/src/modules/posts/presentation/widgets/search_bar_widget.dart';
import 'package:app_tcareer/src/shared/widgets/circular_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(postControllerProvider);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: appBar(),
        // ignore: unnecessary_null_comparison
        body: RefreshIndicator(
          onRefresh: () async => controller.getPost(isRefresh: true),
          child: PagedListView<int, Data>(
            padding: const EdgeInsets.symmetric(vertical: 5),
            pagingController: controller.pagingController,
            builderDelegate: PagedChildBuilderDelegate(
              firstPageProgressIndicatorBuilder: postLoadingWidget,
              itemBuilder: (context, post, index) {
                return GestureDetector(
                  onTap: () => context
                      .goNamed("detail", pathParameters: {"id": "${post.id}"}),
                  child: postWidget(
                      index: index,
                      liked: post.liked ?? false,
                      privacy: post.privacy ?? "",
                      postId: post.id.toString(),
                      ref: ref,
                      context: context,
                      avatarUrl: post.avatar != null
                          ? "${post.avatar}"
                          : "https://mighty.tools/mockmind-api/content/human/45.jpg",
                      userName: post.fullName ?? "",
                      createdAt: post.createdAt ?? "",
                      content: post.body ?? "",
                      images: post.mediaUrl ?? [],
                      likes: post.likeCount != null ? "${post.likeCount}" : "0",
                      comments: post.commentCount != null
                          ? "${post.commentCount}"
                          : "0",
                      shares:
                          post.shareCount != null ? "${post.shareCount}" : "0"),
                );
              },
            ),
          ),
        ));
  }

  PreferredSizeWidget appBar() {
    return AppBar(
      backgroundColor: AppColors.primary,
      // elevation: 2,
      // leading: const ,
      centerTitle: false,
      title: const Text(
        "Bảng tin",
        style: TextStyle(
            fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: GestureDetector(
            child: const PhosphorIcon(
              PhosphorIconsBold.magnifyingGlass,
              color: Colors.white,
              size: 25,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: GestureDetector(
            child: const PhosphorIcon(
              PhosphorIconsBold.chat,
              color: Colors.white,
              size: 25,
            ),
          ),
        ),
        const Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage(
                "https://mighty.tools/mockmind-api/content/human/7.jpg"),
          ),
        )
      ],
    );
  }
}
