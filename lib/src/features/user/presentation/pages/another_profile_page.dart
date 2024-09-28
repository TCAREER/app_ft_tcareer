import 'package:app_tcareer/src/features/posts/presentation/widgets/empty_widget.dart';
import 'package:app_tcareer/src/features/posts/presentation/widgets/post_loading_widget.dart';
import 'package:app_tcareer/src/features/posts/presentation/widgets/post_widget.dart';
import 'package:app_tcareer/src/features/posts/presentation/widgets/shared_post_widget.dart';
import 'package:app_tcareer/src/features/user/presentation/controllers/another_user_controller.dart';
import 'package:app_tcareer/src/features/user/presentation/controllers/user_controller.dart';
import 'package:app_tcareer/src/features/user/presentation/widgets/information.dart';
import 'package:app_tcareer/src/features/user/presentation/widgets/information_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AnotherProfilePage extends ConsumerStatefulWidget {
  final String userId;
  const AnotherProfilePage({super.key,required this.userId});

  @override
  ConsumerState<AnotherProfilePage> createState() => _AnotherProfilePageState();
}

class _AnotherProfilePageState extends ConsumerState<AnotherProfilePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(anotherUserControllerProvider).getUserById(widget.userId);
      ref.read(anotherUserControllerProvider).getPost(widget.userId);
    });
  }



  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(anotherUserControllerProvider);


    return SafeArea(
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: NestedScrollView(

            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  leading: GestureDetector(onTap: ()=>context.pop(), child: const Icon(Icons.arrow_back)),
                  centerTitle: false,
                  toolbarHeight: 30,
                  actions: [
                    PopupMenuButton(
                      color: Colors.white,
                      icon: const Icon(Icons.menu,color: Colors.black,),
                      itemBuilder: (context) {
                        return [
                          
                        ];

                      },
                    )
                  ],
                ),
                SliverToBoxAdapter(child: userInfo()),
                SliverToBoxAdapter(child: buttonFollowAndMessage()),
                const SliverToBoxAdapter(child: SizedBox(height: 5)),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _SliverAppBarDelegate(
                    const TabBar(
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
              children: [
                postList(),
                Text("Ảnh"),
                Text("Video")
              ],
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
      visible: controller.anotherUserData!=null,
      replacement: informationLoading(),
      child: information(
          friends: user?.friendCount.toString(),
          fullName: user?.fullName??"",
          avatar: user?.avatar,
          follows: user?.followerCount.toString()
      ),
    );
  }
  Widget postList(){
    final controller = ref.watch(anotherUserControllerProvider);

    return Visibility(
      visible: !controller.isLoading,
      replacement: postLoadingListViewWidget(context),
      child: Visibility(
        visible: controller.postCache.isNotEmpty,
        replacement: emptyWidget("Không có bài viết nào"),
        child: ListView.builder(
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
                      originUserId: sharedPost?.userId.toString()??"",
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
      ),
    );
  }
  Widget buttonFollowAndMessage() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                SizedBox(
                  height: 35,
                  width: MediaQuery.of(context).size.width * .45,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {},
                    child: const Text("Theo dõi", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * .45,
                  height: 35,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: BorderSide(color: Colors.grey.shade100),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {},
                    child: const Text("Nhắn tin", style: TextStyle(color: Colors.black)),
                  ),
                ),
              ],
            ),
          ),
        ],
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
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
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