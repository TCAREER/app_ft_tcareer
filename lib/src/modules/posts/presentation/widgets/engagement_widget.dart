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
    required String postId,
    required BuildContext context,
    required String likeCount,
    required String commentCount,
    required String shareCount}) {
  final index = ref.watch(indexControllerProvider.notifier);
  final controller = ref.watch(postControllerProvider.notifier);
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 5),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            PhosphorIcon(
              PhosphorIconsBold.heart,
              color: Colors.grey,
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
        const SizedBox(
          width: 10,
        ),
        GestureDetector(
          onTap: () => index.showBottomSheet(
              context: context,
              builder: (scrollController) =>
                  CommentsPage(scrollController: scrollController)),
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
                  "$commentCount",
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
              url: "https://tcareer.thiendev.shop/home/detail/quang%20thien"),
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
