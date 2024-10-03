import 'dart:io';

import 'package:app_tcareer/src/features/posts/presentation/widgets/empty_widget.dart';
import 'package:app_tcareer/src/features/posts/presentation/widgets/post_loading_widget.dart';
import 'package:app_tcareer/src/features/posts/presentation/widgets/post_widget.dart';
import 'package:app_tcareer/src/features/posts/presentation/widgets/shared_post_widget.dart';
import 'package:app_tcareer/src/features/user/presentation/controllers/user_controller.dart';
import 'package:app_tcareer/src/features/user/presentation/widgets/information.dart';
import 'package:app_tcareer/src/features/user/presentation/widgets/information_loading.dart';
import 'package:app_tcareer/src/widgets/circular_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage>
    with SingleTickerProviderStateMixin {
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(userControllerProvider).getUserInfo();
      ref.read(userControllerProvider).getPost();
    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    String? reload = GoRouterState.of(context).extra as String?;
    if (reload != null) {
      scrollController.jumpTo(0);
    }
    Future.microtask(() {
      ref.read(userControllerProvider).getUserInfo();
      ref.read(userControllerProvider).getPost();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(userControllerProvider);
    return SafeArea(
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: NestedScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  toolbarHeight: 30,
                  centerTitle: false,
                  actions: [
                    PopupMenuButton(
                      color: Colors.white,
                      icon: const Icon(
                        Icons.menu,
                        color: Colors.black,
                      ),
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(
                            onTap: () async => await controller.logout(context),
                            child: const ListTile(
                              leading: Icon(
                                Icons.logout,
                                color: Colors.red,
                              ),
                              title: Text("Đăng xuất"),
                            ),
                          )
                        ];
                      },
                    )
                  ],
                ),
                SliverToBoxAdapter(child: userInfo()),
                // SliverToBoxAdapter(child: buttonFollowAndMessage()),
                const SliverToBoxAdapter(child: SizedBox(height: 10)),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _SliverAppBarDelegate(
                    TabBar(
                      overlayColor:
                          MaterialStateProperty.all(Colors.transparent),
                      indicatorWeight: 2,
                      dividerColor: Colors.transparent,
                      indicatorColor: Colors.black,
                      labelStyle: const TextStyle(color: Colors.black),
                      tabs: [
                        Tab(text: "Bài viết"),
                        Tab(text: "Ảnh"),
                        Tab(text: "Video"),
                      ],
                    ),
                  ),
                ),
              ];
            },
            body: TabBarView(
              children: [postList(), Text("Ảnh"), Text("Video")],
            ),
          ),
        ),
      ),
    );
  }

  Widget userInfo() {
    final controller = ref.watch(userControllerProvider);
    final user = controller.userData?.data;
    return Visibility(
      visible: controller.userData != null,
      replacement: informationLoading(),
      child: information(
          ref: ref,
          context: context,
          userId: user?.id.toString(),
          friends: user?.friendCount.toString(),
          fullName: user?.fullName ?? "",
          avatar: user?.avatar,
          follows: user?.followerCount.toString()),
    );
  }

  Widget postList() {
    final controller = ref.watch(userControllerProvider);
    return Visibility(
      visible: controller.postData != null,
      replacement: postLoadingListViewWidget(context),
      child: Visibility(
        visible: controller.postCache.isNotEmpty,
        replacement: emptyWidget("Không có bài viết nào"),
        child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            // Kiểm tra xem đã cuộn đến cuối danh sách chưa
            if (scrollInfo.metrics.pixels >=
                scrollInfo.metrics.maxScrollExtent - 50) {
              // Gọi hàm tải thêm bài viết
              controller.loadMore();
            }
            return true; // Ngăn chặn việc lan truyền thêm
          },
          child: RefreshIndicator(
            onRefresh: () => controller.onRefresh(),
            child: ListView(
              // physics: const NeverScrollableScrollPhysics(),
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.postCache.length,
                  itemBuilder: (context, index) {
                    final post = controller.postCache[index];
                    final sharedPost = post.sharedPost;
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Visibility(
                            replacement: sharedPostWidget(
                              onLike: () async => await controller.postLikePost(
                                  index: index, postId: post.id.toString()),
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
                              index: index,
                            ),
                            visible: post.sharedPostId == null,
                            child: postWidget(
                              onLike: () async => await controller.postLikePost(
                                  index: index, postId: post.id.toString()),
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
                        if (index < controller.postCache.length - 1)
                          Divider(height: 1, color: Colors.grey.shade100),
                      ],
                    );
                  },
                ),
                Visibility(
                  visible: controller.isLoadingMore,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: circularLoadingWidget(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _SliverAppBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Material(
      color: Colors.white,
      elevation: 0.0,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
