import 'package:app_tcareer/src/configs/app_colors.dart';
import 'package:app_tcareer/src/modules/posts/data/models/posts_response.dart';
import 'package:app_tcareer/src/modules/posts/presentation/controllers/post_controller.dart';
import 'package:app_tcareer/src/modules/posts/presentation/posts_provider.dart';
import 'package:app_tcareer/src/modules/posts/presentation/widgets/post_loading_widget.dart';
import 'package:app_tcareer/src/modules/posts/presentation/widgets/post_widget.dart';
import 'package:app_tcareer/src/shared/widgets/circular_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(postControllerProvider).getPost();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(postControllerProvider);
    final postingController = ref.watch(postingControllerProvider);
    bool hasData = controller.postCache.isNotEmpty;

    return SafeArea(
      top: true,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: RefreshIndicator(
          onRefresh: () async => await controller.refresh(),
          child: CustomScrollView(
            controller: controller.scrollController,
            slivers: [
              sliverAppBar(),
              postingLoading(ref),
              SliverVisibility(
                  visible: controller.postCache.isNotEmpty,
                  replacementSliver: postLoadingWidget(context),
                  sliver: sliverPost(ref)),
              SliverToBoxAdapter(
                child: Visibility(
                  visible: hasData &&
                      controller.postCache.length !=
                          controller.postData?.meta?.total,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: circularLoadingWidget(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget sliverPost(WidgetRef ref) {
    final controller = ref.watch(postControllerProvider);
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final post = controller.postCache[index];
          return GestureDetector(
            onTap: () =>
                context.goNamed("detail", pathParameters: {"id": "${post.id}"}),
            child: postWidget(
              index: index,
              liked: post.liked ?? false,
              privacy: post.privacy ?? "",
              postId: post.id.toString(),
              ref: ref,
              context: context,
              avatarUrl: post.avatar ??
                  "https://mighty.tools/mockmind-api/content/human/45.jpg",
              userName: post.fullName ?? "",
              createdAt: post.createdAt ?? "",
              content: post.body ?? "",
              mediaUrl: post.mediaUrl,
              likes: post.likeCount?.toString() ?? "0",
              comments: post.commentCount?.toString() ?? "0",
              shares: post.shareCount?.toString() ?? "0",
            ),
          );
        },
        childCount: controller.isLoading ? 5 : controller.postCache.length,
      ),
    );
  }

  Widget sliverAppBar() {
    return SliverAppBar(
      backgroundColor: Colors.white,
      floating: true,
      pinned: false, // AppBar không cố định
      title: const Text(
        "tcareer",
        style: TextStyle(
          fontSize: 25,
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: GestureDetector(
            child: const PhosphorIcon(
              PhosphorIconsBold.magnifyingGlass,
              color: Colors.black,
              size: 20,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: GestureDetector(
            child: const PhosphorIcon(
              PhosphorIconsBold.chat,
              color: Colors.black,
              size: 20,
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage(
                "https://mighty.tools/mockmind-api/content/human/7.jpg"),
          ),
        ),
      ],
    );
  }

  Widget postingLoading(WidgetRef ref) {
    final postingController = ref.watch(postingControllerProvider);
    return SliverToBoxAdapter(
      child: Visibility(
        visible: postingController.isLoading == true,
        child: Padding(
          padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                    width: 10,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Đang tải bài viết lên...",
                    style: TextStyle(fontSize: 11),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Divider(
                  color: Colors.grey.shade100,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
