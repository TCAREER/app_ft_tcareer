import 'package:app_tcareer/src/configs/app_colors.dart';
import 'package:app_tcareer/src/modules/posts/presentation/controllers/post_controller.dart';
import 'package:app_tcareer/src/modules/posts/presentation/posts_provider.dart';
import 'package:app_tcareer/src/modules/posts/presentation/widgets/post_loading_widget.dart';
import 'package:app_tcareer/src/modules/posts/presentation/widgets/post_widget.dart';
import 'package:app_tcareer/src/modules/posts/presentation/widgets/search_bar_widget.dart';
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
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    Future.delayed(Duration.zero, () {
      ref.read(postControllerProvider).getPost();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(postControllerProvider);
    return Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
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
        ),
        body: controller.isLoading ? postLoadingWidget() : postList(ref));
  }

  Widget postList(WidgetRef ref) {
    final controller = ref.watch(postControllerProvider);
    return RefreshIndicator(
      onRefresh: () async => await controller.getPost(),
      child: ListView.separated(
        separatorBuilder: (context, index) => const SizedBox(
          height: 10,
        ),
        padding: const EdgeInsets.symmetric(vertical: 10),
        itemCount:
            controller.isLoading ? 5 : controller.postData.data?.length ?? 0,
        itemBuilder: (context, index) {
          final post = controller.postData.data?[index];
          return postWidget(
              postId: post?.title ?? "",
              ref: ref,
              context: context,
              avatarUrl: post?.avatar != null
                  ? "${post?.avatar}"
                  : "https://ui-avatars.com/api/?name=${post?.fullName}&background=random",
              userName: post?.fullName ?? "",
              createdAt: post?.createdAt ?? "",
              content: post?.body ?? "",
              images: post?.mediaUrl ?? [],
              likes: post?.likeCount.toString() ?? "",
              comments: post?.commentCount.toString() ?? "",
              shares: post?.shareCount.toString() ?? "");
        },
      ),
    );
  }
}
