import 'package:app_tcareer/src/modules/posts/presentation/controllers/comment_controller.dart';
import 'package:app_tcareer/src/modules/posts/presentation/widgets/comment_item_widget.dart';
import 'package:app_tcareer/src/modules/posts/presentation/widgets/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinput/pinput.dart';

class CommentsPage extends ConsumerStatefulWidget {
  final ScrollController scrollController;
  final int postId;
  const CommentsPage(
      {super.key, required this.postId, required this.scrollController});

  @override
  ConsumerState<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends ConsumerState<CommentsPage> {
  ScrollController scrollController = ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() {
      final controller = ref.watch(commentControllerProvider);
      controller.getCommentByPostId(widget.postId.toString());
      controller.listenToComments(widget.postId.toString());
    });
    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        FocusScope.of(context).unfocus();
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(commentControllerProvider);
    return ClipRRect(
      borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: RefreshIndicator(
          onRefresh: () async =>
              await controller.getCommentByPostId(widget.postId.toString()),
          child: Column(
            children: [
              appBar(),
              Divider(
                // thickness: 0.1,
                color: Colors.grey.shade200,
              ),
              Expanded(child: items(ref))
            ],
          ),
        ),
        bottomNavigationBar: bottomAppBar(ref, context),
      ),
    );
  }

  Widget appBar() {
    return SizedBox(
      height: 50, // Kích thước của AppBar
      child: CustomScrollView(
        controller: widget.scrollController,
        slivers: [
          SliverAppBar(
            elevation: 0.5,
            toolbarHeight: 50,
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(5)),
                  width: 30,
                  height: 4,
                ),
                const SizedBox(height: 10),
                const Text(
                  "Bình luận",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            pinned: true,
            expandedHeight: 100.0,
            flexibleSpace: const FlexibleSpaceBar(),
          ),
        ],
      ),
    );
  }

  Widget items(WidgetRef ref) {
    final controller = ref.watch(commentControllerProvider);
    final comments = controller.commentData?.entries.toList();

    return Visibility(
      visible: controller.commentData?.isNotEmpty == true,
      replacement: emptyWidget("Không có bình luận!"),
      child: ListView.separated(
        controller: scrollController,
        itemCount: comments?.length ?? 0,
        itemBuilder: (context, index) {
          final comment = comments?[index].value;
          return commentItemWidget(index, comment, ref, context);
        },
        separatorBuilder: (context, index) => const SizedBox(
          height: 10,
        ),
      ),
    );
  }

  Widget commentInput(WidgetRef ref, BuildContext context) {
    final controller = ref.watch(commentControllerProvider);

    return SizedBox(
      height: 45,
      child: TextField(
        onChanged: (val) => controller.setHasContent(val),
        controller: controller.contentController,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        decoration: InputDecoration(
          suffix: Visibility(
            visible: controller.hasContent,
            child: GestureDetector(
              onTap: () async => await controller.postCreateComment(
                postId: widget.postId,
                context: context,
              ),
              child: Container(
                padding: const EdgeInsets.all(
                    5), // Thêm padding để làm cho nút đẹp hơn
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
          hintText: controller.hintText != null
              ? controller.hintText
              : "Thêm bình luận...",
          hintStyle: TextStyle(fontSize: 12),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.grey.shade200)),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.grey.shade200)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.grey.shade200)),
        ),
      ),
    );
  }

  Widget bottomAppBar(WidgetRef ref, BuildContext context) {
    return BottomAppBar(
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                      "https://mighty.tools/mockmind-api/content/human/39.jpg"),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 6,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                commentInput(ref, context),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
