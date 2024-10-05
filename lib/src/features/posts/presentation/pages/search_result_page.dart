import 'package:app_tcareer/src/features/posts/presentation/posts_provider.dart';
import 'package:app_tcareer/src/features/posts/presentation/widgets/empty_widget.dart';
import 'package:app_tcareer/src/features/posts/presentation/widgets/post_widget.dart';
import 'package:app_tcareer/src/features/posts/presentation/widgets/search_bar_widget.dart';
import 'package:app_tcareer/src/features/posts/presentation/widgets/shared_post_widget.dart';
import 'package:app_tcareer/src/widgets/circular_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class SearchResultPage extends ConsumerStatefulWidget {
  final String query;
  const SearchResultPage(this.query, {super.key});

  @override
  ConsumerState<SearchResultPage> createState() => _SearchResultPageState();
}

class _SearchResultPageState extends ConsumerState<SearchResultPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() {
      ref.read(searchPostControllerProvider).search(widget.query);
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(searchPostControllerProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        leadingWidth: 40,
        automaticallyImplyLeading: false,
        title: searchBarWidget(
          readOnly: true,
          onTap: () => context.pushReplacementNamed("search"),
          controller: controller.queryController,
        ),
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async => await controller.search(widget.query),
        child: Visibility(
          visible: !controller.isLoading,
          replacement: circularLoadingWidget(),
          child: Visibility(
            visible: controller.users.isNotEmpty || controller.posts.isNotEmpty,
            replacement: emptyWidget("Không tìm thấy dữ liệu"),
            child: ListView(
              padding: EdgeInsets.symmetric(vertical: 10),
              children: [
                userList(),
                Visibility(
                    visible: controller.users.isNotEmpty &&
                        controller.posts.isNotEmpty,
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      width: ScreenUtil().scaleWidth,
                      color: Colors.grey.shade200,
                      height: 10,
                    )),
                postList()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget userList() {
    final controller = ref.watch(searchPostControllerProvider);
    return Visibility(
      visible: controller.users.isNotEmpty,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              "Mọi người",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Column(
            children: controller.users.map((user) {
              return ListTile(
                tileColor: Colors.white,
                onTap: () => context.pushNamed('profile',
                    queryParameters: {"userId": user.id.toString()}),
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(user.avatar ??
                      "https://ui-avatars.com/api/?name=${user.fullName}&background=random"),
                ),
                title: Text(user.fullName ?? ""),
                trailing: IconButton(
                  onPressed: () {},
                  icon: PhosphorIcon(PhosphorIconsLight.userCirclePlus),
                ),
              );
            }).toList(),
          )
        ],
      ),
    );
  }

  Widget postList() {
    final controller = ref.watch(searchPostControllerProvider);
    return Visibility(
      visible: controller.posts.isNotEmpty,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              "Bài đăng",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Column(
            children: controller.posts.asMap().entries.map((entry) {
              final post = entry.value;
              final index = entry.key;
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
                          index: index),
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
                  if (index < controller.posts.length - 1)
                    Divider(
                      height: 1,
                      color: Colors.grey.shade100,
                    ),
                ],
              );
            }).toList(),
          )
        ],
      ),
    );
  }
}
