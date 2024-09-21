import 'dart:ui';
import 'package:app_tcareer/src/configs/app_colors.dart';
import 'package:app_tcareer/src/modules/index/index_controller.dart';
import 'package:app_tcareer/src/modules/posts/presentation/controllers/post_controller.dart';
import 'package:app_tcareer/src/modules/posts/presentation/pages/comments_page.dart';
import 'package:app_tcareer/src/modules/posts/presentation/posts_provider.dart';
import 'package:app_tcareer/src/shared/widgets/reaction_item_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

Widget engagementWidget(
    {required WidgetRef ref,
    required int index,
    required bool liked,
    required String postId,
    required BuildContext context,
    required String likeCount,
    required String commentCount,
    required String shareCount}) {
  final indexController = ref.watch(indexControllerProvider.notifier);
  final controller = ref.watch(postControllerProvider.notifier);
  // bool likedPost = controller.getLikePosts(postId);
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () async =>
              controller.postLikePost(index: index, postId: postId),
          child: Row(
            children: [
              PhosphorIcon(
                liked != true
                    ? PhosphorIconsBold.heart
                    : PhosphorIconsFill.heart,
                color: liked != true ? Colors.grey : Colors.red,
                size: 20,
              ),
              const SizedBox(
                width: 3,
              ),
              Visibility(
                visible: likeCount != "0",
                child: Text(
                  "$likeCount",
                  style: TextStyle(color: Colors.grey),
                ),
              )
            ],
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        GestureDetector(
          onTap: () => indexController.showBottomSheet(
              context: context,
              builder: (scrollController) => CommentsPage(
                    postId: int.parse(postId),
                    scrollController: scrollController,
                  )),
          child: Row(
            children: [
              PhosphorIcon(
                PhosphorIconsBold.chatCircle,
                color: Colors.grey,
                size: 20,
              ),
              const SizedBox(
                width: 3,
              ),
              Visibility(
                visible: commentCount != "0",
                child: Text(
                  commentCount,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        GestureDetector(
          onTap: () => controller.sharePost(
              title: "Bài viết",
              url: "https://tcareer.thiendev.shop/home/detail/$postId"),
          child: Row(
            children: [
              PhosphorIcon(
                PhosphorIconsBold.paperPlaneTilt,
                color: Colors.grey,
                size: 20,
              ),
              const SizedBox(
                width: 3,
              ),
              Visibility(
                visible: commentCount != "0",
                child: Text(
                  "$shareCount",
                  style: TextStyle(color: Colors.grey),
                ),
              )
            ],
          ),
        ),
      ],
    ),
  );
}
