import 'package:app_tcareer/src/features/posts/presentation/widgets/empty_widget.dart';
import 'package:app_tcareer/src/features/posts/presentation/widgets/post_loading_widget.dart';
import 'package:app_tcareer/src/features/posts/presentation/widgets/post_widget.dart';
import 'package:app_tcareer/src/features/posts/presentation/widgets/shared_post_widget.dart';
import 'package:app_tcareer/src/features/user/presentation/controllers/another_user_controller.dart';
import 'package:app_tcareer/src/features/user/presentation/controllers/user_connection_controller.dart';
import 'package:app_tcareer/src/features/user/presentation/controllers/user_controller.dart';
import 'package:app_tcareer/src/features/user/presentation/widgets/connect_button.dart';
import 'package:app_tcareer/src/features/user/presentation/widgets/information.dart';
import 'package:app_tcareer/src/features/user/presentation/widgets/information_loading.dart';
import 'package:app_tcareer/src/widgets/circular_loading_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class AnotherProfilePage extends ConsumerStatefulWidget {
  final String userId;
  const AnotherProfilePage({super.key, required this.userId});

  @override
  ConsumerState<AnotherProfilePage> createState() => _AnotherProfilePageState();
}

class _AnotherProfilePageState extends ConsumerState<AnotherProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(anotherUserControllerProvider).page = 1;
      ref.read(anotherUserControllerProvider).getUserById(widget.userId);
      ref.read(anotherUserControllerProvider).getPost(widget.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(anotherUserControllerProvider);
    final user = controller.anotherUserData?.data;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  leading: GestureDetector(
                      onTap: () => context.pop(),
                      child: const Icon(Icons.arrow_back)),
                  centerTitle: false,
                  toolbarHeight: 30,
                  actions: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: GestureDetector(
                        onTap: () => controller.showMenu(context),
                        child: PhosphorIcon(
                          PhosphorIconsRegular.dotsThreeCircle,
                        ),
                      ),
                    )
                  ],
                ),
                SliverToBoxAdapter(child: userInfo()),
                SliverToBoxAdapter(
                    child: buttonConnectAndMessage(
                        user?.friendStatus ?? "default")),
                const SliverToBoxAdapter(child: SizedBox(height: 5)),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _SliverAppBarDelegate(
                    TabBar(
                      overlayColor:
                          MaterialStateProperty.all(Colors.transparent),
                      dividerColor: Colors.transparent,
                      indicatorWeight: 2,
                      indicatorColor: Colors.black,
                      labelStyle: const TextStyle(color: Colors.black),
                      tabs: const [
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
    final controller = ref.watch(anotherUserControllerProvider);
    final user = controller.anotherUserData?.data;
    return Visibility(
      visible: controller.anotherUserData != null,
      replacement: informationLoading(),
      child: information(
          userId: user?.id.toString(),
          ref: ref,
          context: context,
          friends: user?.friendCount.toString(),
          fullName: user?.fullName ?? "",
          avatar: user?.avatar,
          follows: user?.followerCount.toString()),
    );
  }

  Widget postList() {
    final controller = ref.watch(anotherUserControllerProvider);
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        // Kiểm tra xem đã cuộn đến cuối danh sách chưa
        if (scrollInfo.metrics.pixels >=
            scrollInfo.metrics.maxScrollExtent - 50) {
          // Gọi hàm tải thêm bài viết
          controller.loadMore();
        }
        return true; // Ngăn chặn việc lan truyền thêm
      },
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          CupertinoSliverRefreshControl(
            onRefresh: () async => await controller.refresh(),
          ),
          SliverVisibility(
            visible: controller.postData != null,
            replacementSliver: postLoadingWidget(context),
            sliver: SliverVisibility(
              visible: controller.postCache.isNotEmpty,
              replacementSliver: SliverToBoxAdapter(
                child: emptyWidget("Không có bài viết nào"),
              ),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final post = controller.postCache[index];
                    final sharedPost = post.sharedPost;
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Visibility(
                            replacement: sharedPostWidget(
                              privacyOrigin: sharedPost?.privacy ?? "",
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
                        // if (index < controller.postCache.length - 1)
                        //   Divider(height: 1, color: Colors.grey.shade100),
                      ],
                    );
                  },
                  childCount: controller.postCache.length,
                ),
              ),
            ),
          ),
          if (controller.isLoadingMore)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: circularLoadingWidget(),
              ),
            ),
        ],
      ),
    );
  }

  Widget buttonConnectAndMessage(String? friendStatus) {
    final controller = ref.watch(anotherUserControllerProvider);
    String userId = controller.anotherUserData?.data?.id.toString() ?? "";
    final connectionController =
        ref.watch(userConnectionControllerProvider(userId));
    final userController = ref.watch(userControllerProvider);

    return Visibility(
      visible: controller.anotherUserData != null,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            connectButton(
              friendStatus: friendStatus ?? "default",
              onConnect: () async =>
                  await connectionController.postAddFriend(context),
              onConfirm: () async => await connectionController
                  .showModalConfirmRequest(context: context),
              onCancelRequest: () async =>
                  await connectionController.cancelRequest(context),
              onDelete: () async => await connectionController
                  .showModalDeleteFriend(context: context),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: SizedBox(
                height: 35,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: BorderSide(color: Colors.grey.shade200, width: 1.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () => context.pushNamed("chat", pathParameters: {
                    "userId":
                        controller.anotherUserData?.data?.id.toString() ?? "",
                    "clientId":
                        userController.userData?.data?.id.toString() ?? ""
                  }),
                  child: const Text("Nhắn tin",
                      style: TextStyle(color: Colors.black)),
                ),
              ),
            ),
          ],
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
