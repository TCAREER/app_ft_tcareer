import 'package:app_tcareer/src/configs/app_colors.dart';
import 'package:app_tcareer/src/features/posts/data/models/posts_response.dart';
import 'package:app_tcareer/src/features/posts/presentation/controllers/post_controller.dart';
import 'package:app_tcareer/src/features/posts/presentation/posts_provider.dart';
import 'package:app_tcareer/src/features/posts/presentation/widgets/empty_widget.dart';
import 'package:app_tcareer/src/features/posts/presentation/widgets/post_loading_widget.dart';
import 'package:app_tcareer/src/features/posts/presentation/widgets/post_widget.dart';
import 'package:app_tcareer/src/features/posts/presentation/widgets/shared_post_widget.dart';
import 'package:app_tcareer/src/features/user/presentation/controllers/user_controller.dart';

import 'package:app_tcareer/src/widgets/circular_loading_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  // bool hasRefreshed = false;
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(postControllerProvider).postCache.clear();
      ref.read(postControllerProvider).getPost();
      ref.read(userControllerProvider).getUserInfo();
    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    var extra = GoRouterState.of(context).extra;
    if (extra == "reload") {
      print(">>>>>>>>>>>B");
      Future.microtask(() {
        ref.read(postControllerProvider).scrollToTop();
        ref.watch(postControllerProvider).refresh();
        extra = null;
      });

      // hasRefreshed = true;
    }

    //

    //
    // if (extra == "create") {
    //   Future.microtask(()
    //     ref.read(postControllerProvider).scrollToTop();
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(postControllerProvider);

    bool hasData = controller.postCache.isNotEmpty;

    return SafeArea(
      top: true,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          controller: controller.scrollController,
          slivers: [
            CupertinoSliverRefreshControl(
              onRefresh: () async => await controller.refresh(),
            ),
            sliverAppBar(ref),
            SliverVisibility(
                visible: controller.postData != null,
                replacementSliver: postLoadingWidget(context),
                sliver: SliverVisibility(
                    visible: controller.postData?.data?.isNotEmpty == true,
                    replacementSliver: SliverFillRemaining(
                      child: emptyWidget("Không có bài viết nào"),
                    ),
                    sliver: sliverPost(ref))),
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
    );
  }

  Widget sliverPost(WidgetRef ref) {
    final controller = ref.watch(postControllerProvider);
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final post = controller.postCache[index];
          final sharedPost = controller.postCache[index].sharedPost;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Visibility(
                  replacement: sharedPostWidget(
                      onLike: () async => await controller.postLikePost(
                            index: index,
                            postId: post.id.toString(),
                          ),
                      originUserId: sharedPost?.userId.toString() ?? "",
                      userId: post.userId.toString(),
                      originCreatedAt: sharedPost?.createdAt ?? "",
                      originPostId: sharedPost?.id.toString() ?? "",
                      mediaUrl: sharedPost?.mediaUrl,
                      context: context,
                      ref: ref,
                      avatarUrl: post.avatar ??
                          "https://ui-avatars.com/api/?name=${post.fullName}&background=random",
                      userName: post.fullName ?? "",
                      userNameOrigin: sharedPost?.fullName ?? "",
                      avatarUrlOrigin: sharedPost?.avatar ??
                          "https://ui-avatars.com/api/?name=${sharedPost?.fullName}&background=random",
                      createdAt: post.createdAt ?? "",
                      content: post.body ?? "",
                      contentOrigin: sharedPost?.body ?? "",
                      liked: post.liked ?? false,
                      likes: post.likeCount?.toString() ?? "0",
                      comments: post.commentCount?.toString() ?? "0",
                      shares: post.shareCount?.toString() ?? "0",
                      privacy: post.privacy ?? "",
                      postId: post.id.toString(),
                      index: index),
                  visible: post.sharedPostId == null,
                  child: postWidget(
                    onLike: () async => await controller.postLikePost(
                      index: index,
                      postId: post.id.toString(),
                    ),
                    userId: post.userId.toString(),
                    index: index,
                    liked: post.liked ?? false,
                    privacy: post.privacy ?? "",
                    postId: post.id.toString(),
                    ref: ref,
                    context: context,
                    avatarUrl: post.avatar ??
                        "https://ui-avatars.com/api/?name=${post.fullName}&background=random",
                    userName: post.fullName ?? "",
                    createdAt: post.createdAt ?? "",
                    content: post.body ?? "",
                    mediaUrl: post.mediaUrl,
                    likes: post.likeCount?.toString() ?? "0",
                    comments: post.commentCount?.toString() ?? "0",
                    shares: post.shareCount?.toString() ?? "0",
                  ),
                ),
              ),
              // if (index < controller.postCache.length - 1)
              //   Divider(
              //     height: 1,
              //     color: Colors.grey.shade100,
              //   ),
            ],
          );
        },
        childCount: controller.isLoading ? 5 : controller.postCache.length,
      ),
    );
  }

  Widget sliverAppBar(WidgetRef ref) {
    final postingController = ref.watch(postingControllerProvider);

    return SliverAppBar(
      // leading: Column(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: [
      //     CircleAvatar(
      //       radius: 18,
      //       backgroundImage: NetworkImage(userData.avatar ??
      //           "https://ui-avatars.com/api/?name=${userData.fullName}&background=random"),
      //     ),
      //   ],
      // ),
      automaticallyImplyLeading: false,
      centerTitle: false,
      backgroundColor: Colors.white,
      floating: true,
      pinned: false, // AppBar không cố định
      title: const Text(
        "Bài đăng",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
      ),
      // leadingWidth: 120,
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: GestureDetector(
            onTap: () => context.goNamed('search'),
            child: const PhosphorIcon(
              PhosphorIconsRegular.magnifyingGlass,
              color: Colors.black,
              size: 20,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: GestureDetector(
            child: const PhosphorIcon(
              PhosphorIconsRegular.chatCenteredDots,
              color: Colors.black,
              size: 20,
            ),
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: postingController.isLoading == true
            ? const Size.fromHeight(30)
            : const Size.fromHeight(0),
        child: postingLoading(ref),
      ),
    );
  }

  Widget postingLoading(WidgetRef ref) {
    final postingController = ref.watch(postingControllerProvider);
    return Visibility(
      visible: postingController.isLoading == true,
      child: Padding(
        padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
        child: Column(
          children: [
            const Row(
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
                SizedBox(
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
    );
  }
}
