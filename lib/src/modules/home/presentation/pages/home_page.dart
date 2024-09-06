import 'package:app_tcareer/src/configs/app_colors.dart';
import 'package:app_tcareer/src/modules/home/presentation/controllers/post_controller.dart';
import 'package:app_tcareer/src/modules/home/presentation/widgets/post_loading_widget.dart';
import 'package:app_tcareer/src/modules/home/presentation/widgets/post_widget.dart';
import 'package:app_tcareer/src/modules/home/presentation/widgets/search_bar_widget.dart';
import 'package:app_tcareer/src/shared/widgets/circular_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
      ref.read(postControllerProvider.notifier).getPost();
    });
  }

  @override
  Widget build(BuildContext context) {
    final postState = ref.watch(postControllerProvider);
    return Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          // elevation: 2,
          leading: const Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(
                  "https://mighty.tools/mockmind-api/content/human/7.jpg"),
            ),
          ),
          centerTitle: true,
          title: searchBarWidget(),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: GestureDetector(
                child: const PhosphorIcon(
                  PhosphorIconsBold.chatCircle,
                  color: AppColors.primary,
                  size: 28,
                ),
              ),
            )
          ],
        ),
        body: postState.isLoading ? postLoadingWidget() : postList(ref));
  }

  Widget postList(WidgetRef ref) {
    final postState = ref.watch(postControllerProvider);
    return ListView.separated(
      separatorBuilder: (context, index) => const SizedBox(
        height: 10,
      ),
      padding: const EdgeInsets.symmetric(vertical: 10),
      itemCount:
          postState.isLoading ? 5 : postState.postData?.articles?.length ?? 0,
      itemBuilder: (context, index) {
        final post = postState.postData?.articles?[index];
        return postWidget(
            postId: post?.title ?? "",
            ref: ref,
            context: context,
            avatarUrl:
                "https://ui-avatars.com/api/?name=${post?.author}&background=random",
            userName: post?.author ?? "",
            subName: post?.source?.name ?? "",
            createdAt: post?.publishedAt ?? "",
            content: post?.title ?? "",
            imageUrl: post?.urlToImage ??
                "https://vatvostudio.vn/wp-content/uploads/2024/08/Gooogle-Tensor-G4.jpg",
            likes: " 99",
            comments: "12",
            shares: "18");
      },
    );
  }
}
