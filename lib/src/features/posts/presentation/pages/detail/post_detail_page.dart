import 'package:app_tcareer/src/features/posts/data/models/posts_detail_response.dart';
import 'package:app_tcareer/src/features/posts/presentation/widgets/post_widget.dart';
import 'package:app_tcareer/src/features/posts/usecases/post_use_case.dart';
import 'package:app_tcareer/src/widgets/circular_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final getPostByIdProvider =
    FutureProvider.family<PostsDetailResponse, String>((ref, postId) {
  final postUseCase = ref.watch(postUseCaseProvider);
  return postUseCase.getPostById(postId);
});

class PostDetailPage extends ConsumerWidget {
  final String postId;
  const PostDetailPage(this.postId, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postRes = ref.watch(getPostByIdProvider(postId));
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1.1,
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: const Text("Bài viết"),
          titleTextStyle:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          leading: IconButton(
              onPressed: () => context.goNamed('home'),
              icon: const Icon(Icons.arrow_back)),
        ),
        body: postRes.when(
          data: (postData) {
            final post = postData.data;
            return ListView(
              children: [
                postWidget(
                    onLike: (){},
                    userId: post?.userId.toString()??"",
                    index: 0,
                    liked: post?.liked ?? false,
                    privacy: post?.privacy ?? "",
                    postId: post?.id.toString() ?? "",
                    ref: ref,
                    context: context,
                    avatarUrl: post?.avatar != null
                        ? "${post?.avatar}"
                        : "https://mighty.tools/mockmind-api/content/human/45.jpg",
                    userName: post?.fullName ?? "",
                    createdAt: post?.createdAt ?? "",
                    content: post?.body ?? "",
                    mediaUrl: post?.mediaUrl ?? [],
                    likes: post?.likeCount != null ? "${post?.likeCount}" : "0",
                    comments: post?.commentCount != null
                        ? "${post?.commentCount}"
                        : "0",
                    shares:
                        post?.shareCount != null ? "${post?.shareCount}" : "0"),
              ],
            );
          },
          error: (error, stackTrace) {},
          loading: () => circularLoadingWidget(),
        ));
  }
}
