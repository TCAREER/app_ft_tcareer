import 'dart:io';

import 'package:app_tcareer/src/configs/app_colors.dart';
import 'package:app_tcareer/src/modules/posts/presentation/controllers/media_controller.dart';
import 'package:app_tcareer/src/modules/posts/presentation/posts_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_fb_photo_view/flutter_fb_photo_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class PostingPage extends ConsumerStatefulWidget {
  const PostingPage({super.key});

  @override
  ConsumerState<PostingPage> createState() => _PostingPageState();
}

class _PostingPageState extends ConsumerState<PostingPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(
        () => ref.read(postingControllerProvider).loadCacheImage());
  }

  @override
  Widget build(BuildContext context) {
    final mediaController = ref.watch(mediaControllerProvider);
    final controller = ref.watch(postingControllerProvider);
    return PopScope(
      onPopInvoked: (didPop) {
        if (didPop) {
          controller.showDialog(context);
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        appBar: appBar(
            context: context,
            onPop: () => controller.showDialog(context),
            onPosting: () => controller.createPost()),
        body: ListView(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(
                      "https://mighty.tools/mockmind-api/content/human/7.jpg"),
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Quang Thiện",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    objectWidget()
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            postInput(controller.contentController),
            const SizedBox(
              height: 10,
            ),
            Visibility(
              visible: mediaController.imagePaths.isNotEmpty,
              child: FBPhotoView(
                dataSource: mediaController.imagePaths,
                displayType: FBPhotoViewType.grid5,
              ),
            ),
            Text(controller.contentController.text)
          ],
        ),
        bottomNavigationBar: bottomAppBar(context, ref),
      ),
    );
  }

  PreferredSizeWidget appBar(
      {required BuildContext context,
      required void Function()? onPop,
      required void Function()? onPosting}) {
    return AppBar(
      bottom: const PreferredSize(
        child: const Divider(),
        preferredSize: Size.fromHeight(5),
      ),
      backgroundColor: Colors.white,
      leading: IconButton(
        onPressed: onPop,
        icon: const Icon(
          Icons.close,
          color: Colors.black,
        ),
      ),
      centerTitle: true,
      title: const Text("Tạo bài viết"),
      titleTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  backgroundColor: AppColors.executeButton),
              onPressed: onPosting,
              child: const Text(
                "Đăng",
                style: TextStyle(color: Colors.white),
              )),
        )
      ],
    );
  }

  Widget objectWidget() {
    return const Row(
      children: [Text("Mọi người"), Icon(Icons.arrow_drop_down)],
    );
  }

  Widget postInput(TextEditingController controller) {
    return TextField(
      autofocus: true,
      maxLines: null,
      controller: controller,
      keyboardType: TextInputType.multiline,
      decoration: const InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
          hintText: "Hôm nay bạn muốn chia sẻ điều gì?",
          border: InputBorder.none,
          errorBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none),
    );
  }

  Widget bottomAppBar(BuildContext context, WidgetRef ref) {
    final mediaController = ref.watch(mediaControllerProvider);

    return MediaQuery(
      data: MediaQuery.of(context), // Get the MediaQuery data
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100), // Animation duration
        curve: Curves.easeInOut, // Animation curve
        margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom *
                .95), // Adjust bottom margin based on keyboard height
        child: BottomAppBar(
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                  onPressed: () async {
                    await mediaController.getAlbums();

                    context.goNamed("photoManager");
                  },
                  icon: const PhosphorIcon(
                    PhosphorIconsBold.image,
                    color: Colors.grey,
                    size: 30,
                  )),
              const SizedBox(
                width: 10,
              ),
              IconButton(
                  onPressed: () {},
                  icon: const PhosphorIcon(
                    PhosphorIconsBold.link,
                    color: Colors.grey,
                    size: 30,
                  )),
              const SizedBox(
                width: 10,
              ),
              IconButton(
                  onPressed: () {},
                  icon: const PhosphorIcon(
                    PhosphorIconsBold.smiley,
                    color: Colors.grey,
                    size: 30,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
