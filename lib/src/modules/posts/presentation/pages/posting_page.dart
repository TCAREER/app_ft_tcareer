import 'dart:io';

import 'package:app_tcareer/src/configs/app_colors.dart';
import 'package:app_tcareer/src/modules/posts/presentation/controllers/media_controller.dart';
import 'package:app_tcareer/src/modules/posts/presentation/controllers/posting_controller.dart';
import 'package:app_tcareer/src/modules/posts/presentation/posts_provider.dart';
import 'package:app_tcareer/src/modules/posts/presentation/widgets/posting_image_wiget.dart';
import 'package:app_tcareer/src/modules/posts/presentation/widgets/posting_video_player_widget.dart';
import 'package:app_tcareer/src/modules/posts/presentation/widgets/privacy_bottom_sheet_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
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
    Future.microtask(() {
      final controller = ref.read(postingControllerProvider);
      controller.getUserInfo();
      controller.loadPostCache();
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaController = ref.watch(mediaControllerProvider);
    final controller = ref.watch(postingControllerProvider);
    bool isActive = controller.contentController.text != "" ||
        mediaController.imagePaths.isNotEmpty ||
        controller.imagesWeb?.isNotEmpty == true;
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
            isActive: isActive,
            isLoading: controller.isLoading,
            context: context,
            onPop: () => controller.showDialog(context),
            onPosting: () async => await controller.createPost(context)),
        body: ListView(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(controller.userData.avatar ??
                      "https://ui-avatars.com/api/?name=${controller.userData?.fullName}&background=random"),
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.userData.fullName ?? "",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    privacyWidget(controller, context)
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
                visible: mediaController.videoPaths != null ||
                    controller.videoUrlWeb != null,
                child: PostingVideoPlayerWidget()),
            postingImageWidget(mediaUrl: mediaController.imagePaths, ref: ref),
          ],
        ),
        bottomNavigationBar: bottomAppBar(context, ref),
      ),
    );
  }

  PreferredSizeWidget appBar(
      {required bool isActive,
      required BuildContext context,
      required void Function()? onPop,
      required void Function()? onPosting,
      required bool isLoading}) {
    return AppBar(
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(5),
        child: Visibility(
          visible: isLoading,
          replacement: const Divider(),
          child: const LinearProgressIndicator(
            backgroundColor: Colors.white,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
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
        SizedBox(
          height: 30,
          width: 90,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    backgroundColor: AppColors.executeButton),
                onPressed: isActive ? onPosting : null,
                child: const Text(
                  "Đăng",
                  style: TextStyle(color: Colors.white, fontSize: 13),
                )),
          ),
        )
      ],
    );
  }

  Widget privacyWidget(PostingController controller, BuildContext context) {
    return GestureDetector(
      onTap: () => showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (context) => privacyBottomSheetWidget(context: context)),
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.grey.shade200),
        child: Visibility(
          visible: controller.selectedPrivacy.contains("Public"),
          replacement: const Row(
            children: [
              Icon(
                Icons.group,
                size: 15,
              ),
              SizedBox(
                width: 2,
              ),
              const Text(
                "Bạn bè",
                style: TextStyle(fontSize: 12),
              ),
              SizedBox(
                width: 5,
              ),
              Icon(
                Icons.arrow_drop_down,
                size: 15,
              ),
            ],
          ),
          child: const Row(
            children: [
              Icon(
                Icons.public,
                size: 15,
              ),
              const SizedBox(
                width: 2,
              ),
              Text(
                "Công khai",
                style: TextStyle(fontSize: 12),
              ),
              const SizedBox(
                width: 5,
              ),
              Icon(
                Icons.arrow_drop_down,
                size: 15,
              ),
            ],
          ),
        ),
      ),
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
    final controller = ref.watch(postingControllerProvider);
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
                    // await controller.setCacheContent();
                    // await controller.loadContentCache();
                    if (!kIsWeb) {
                      await mediaController.getAlbums();

                      context.goNamed("photoManager");
                    } else {
                      await controller.pickImageWeb();
                    }
                  },
                  icon: const PhosphorIcon(
                    PhosphorIconsBold.image,
                    color: Colors.grey,
                    size: 30,
                  )),
              Visibility(
                visible: kIsWeb,
                child: IconButton(
                    onPressed: () async {
                      await controller.pickVideoWeb(context);
                    },
                    icon: const PhosphorIcon(
                      PhosphorIconsBold.video,
                      color: Colors.grey,
                      size: 30,
                    )),
              ),
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
