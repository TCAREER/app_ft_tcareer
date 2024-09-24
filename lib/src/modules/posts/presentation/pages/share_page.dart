import 'package:app_tcareer/src/configs/app_colors.dart';
import 'package:app_tcareer/src/modules/posts/presentation/posts_provider.dart';
import 'package:app_tcareer/src/modules/posts/presentation/widgets/post_input.dart';
import 'package:app_tcareer/src/modules/posts/presentation/widgets/privacy_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SharePage extends ConsumerWidget {
  final int postId;
  const SharePage(this.postId, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        extendBody: true,
        backgroundColor: Colors.blueGrey.shade50,
        appBar: appBar(),
        body: ListView(
          children: [shareComponent(ref, context)],
        ),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      backgroundColor: Colors.blueGrey.shade50,
      elevation: 0.5,
      toolbarHeight: 30,
      automaticallyImplyLeading: false,
      centerTitle: true,
      title: Container(
        decoration: BoxDecoration(
            color: Colors.grey, borderRadius: BorderRadius.circular(5)),
        width: 30,
        height: 4,
      ),
    );
  }

  Widget shareComponent(WidgetRef ref, BuildContext context) {
    final postController = ref.watch(postControllerProvider);
    final postingController = ref.watch(postingControllerProvider);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 15,
                backgroundImage: NetworkImage(postController.userData.avatar ??
                    "https://ui-avatars.com/api/?name=${postController.userData.fullName}&background=random"),
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    postController.userData.fullName ?? "",
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  privacyWidget(postingController, context)
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          postInput(postController.shareContentController,
              minLines: 3, maxLines: 10),
          const SizedBox(
            height: 10,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              height: 30,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      backgroundColor: AppColors.executeButton),
                  onPressed: () async => await postController.sharePost(
                      postId: postId,
                      privacy: postingController.selectedPrivacy,
                      context: context),
                  child: const Text(
                    "Chia sẻ",
                    style: TextStyle(color: Colors.white, fontSize: 13),
                  )),
            ),
          )
        ],
      ),
    );
  }
}
