import 'dart:io';

import 'package:app_tcareer/src/configs/app_colors.dart';
import 'package:app_tcareer/src/features/posts/data/models/create_post_request.dart';
import 'package:app_tcareer/src/features/posts/presentation/controllers/media_controller.dart';
import 'package:app_tcareer/src/features/posts/presentation/controllers/posting_controller.dart';
import 'package:app_tcareer/src/features/posts/presentation/posts_provider.dart';
import 'package:app_tcareer/src/features/posts/presentation/widgets/post_input.dart';
import 'package:app_tcareer/src/features/posts/presentation/widgets/posting_image_wiget.dart';
import 'package:app_tcareer/src/features/posts/presentation/widgets/posting_video_player_widget.dart';
import 'package:app_tcareer/src/features/posts/presentation/widgets/privacy_bottom_sheet_widget.dart';
import 'package:app_tcareer/src/features/posts/presentation/widgets/privacy_widget.dart';
import 'package:app_tcareer/src/features/user/presentation/controllers/user_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_fb_photo_view/flutter_fb_photo_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class PostingPage extends ConsumerStatefulWidget {
  final CreatePostRequest? body;
  final String? postId;
  final String? action;
  const PostingPage({super.key, this.body, this.postId, this.action});

  @override
  ConsumerState<PostingPage> createState() => _PostingPageState();
}

class _PostingPageState extends ConsumerState<PostingPage> {
  final ScrollController scrollController = ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() {
      final controller = ref.watch(postingControllerProvider);

      controller.loadPostCache();
      if (widget.body != null) {
        controller.setPostEdit(body: widget.body!, postId: widget.postId ?? "");
      }
    });

    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection !=
          ScrollDirection.idle) {
        FocusScope.of(context).unfocus();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaController = ref.watch(mediaControllerProvider);
    final controller = ref.watch(postingControllerProvider);
    final userController = ref.watch(userControllerProvider);
    bool isActive = controller.contentController.text != "" ||
        mediaController.imagePaths.isNotEmpty ||
        controller.imagesWeb.isNotEmpty == true ||
        controller.videoUrlWeb != null ||
        controller.videoPicked != null ||
        mediaController.videoPaths.isNotEmpty == true;
    return BackButtonListener(
      onBackButtonPressed: () async {
        await controller.showDialog(context);
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        appBar: appBar(
            isActive: isActive,
            isLoading: controller.isLoading,
            context: context,
            onPop: () => controller.showDialog(context),
            onPosting: () async {
              if (widget.action == "edit") {
                await controller.updatePost(
                    postId: widget.postId ?? "", context: context);
              } else {
                await controller.createPost(context);
              }
            }),
        body: ListView(
          controller: scrollController,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(userController
                          .userData?.data?.avatar ??
                      "https://ui-avatars.com/api/?name=${userController.userData?.data?.fullName}&background=random"),
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userController.userData?.data?.fullName ?? "",
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
              height: 5,
            ),
            postInput(
                controller: controller.contentController,
                onChanged: controller.setContent),
            const SizedBox(
              height: 5,
            ),
            Visibility(
                visible: mediaController.videoPaths.isNotEmpty,
                child: const PostingVideoPlayerWidget()),
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
        child: Divider(
          color: Colors.grey.shade200,
        ),
      ),
      backgroundColor: Colors.white,
      leading: InkWell(
        onTap: onPop,
        child: const Icon(
          Icons.close,
          color: Colors.black,
        ),
      ),
      centerTitle: false,
      title: Text(
        widget.action != null ? "Chỉnh sửa bài viết" : "Tạo bài viết",
        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
      ),
      titleTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 20,
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
                        borderRadius: BorderRadius.circular(20)),
                    backgroundColor: AppColors.executeButton),
                onPressed: isActive ? onPosting : null,
                child: Text(
                  widget.action != null ? "Lưu" : "Đăng",
                  style: TextStyle(color: Colors.white, fontSize: 13),
                )),
          ),
        )
      ],
    );
  }

  Widget bottomAppBar(BuildContext context, WidgetRef ref) {
    final mediaController = ref.watch(mediaControllerProvider);
    final controller = ref.watch(postingControllerProvider);

    double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      margin: EdgeInsets.only(bottom: keyboardHeight > 0 ? keyboardHeight : 0),
      child: Container(
        height: 48,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () async {
                if (!kIsWeb) {
                  await mediaController.getAlbums();
                  context.pushNamed("photoManager");
                } else {
                  await controller.pickMediaWeb(context);
                }
              },
              icon: const PhosphorIcon(
                PhosphorIconsFill.image,
                color: Colors.grey,
                size: 25,
              ),
            ),

            // IconButton(
            //   onPressed: () {},
            //   icon: const PhosphorIcon(
            //     PhosphorIconsFill.link,
            //     color: Colors.grey,
            //     size: 25,
            //   ),
            // ),

            // IconButton(
            //   onPressed: () {},
            //   icon: const PhosphorIcon(
            //     PhosphorIconsBold.smiley,
            //     color: Colors.grey,
            //     size: 20,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
