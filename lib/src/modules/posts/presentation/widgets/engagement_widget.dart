import 'dart:ui';
import 'package:app_tcareer/src/configs/app_colors.dart';
import 'package:app_tcareer/src/modules/index/index_controller.dart';
import 'package:app_tcareer/src/modules/posts/presentation/controllers/post_controller.dart';
import 'package:app_tcareer/src/modules/posts/presentation/pages/comments_page.dart';
import 'package:app_tcareer/src/shared/widgets/reaction_item_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_reaction/flutter_animated_reaction.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

Widget engagementWidget(WidgetRef ref, String postId, BuildContext context) {
  final index = ref.watch(indexControllerProvider.notifier);
  final controller = ref.watch(postControllerProvider.notifier);
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 5),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        RichText(
            textAlign: TextAlign.center,
            text: const TextSpan(children: [
              WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: PhosphorIcon(
                    PhosphorIconsBold.heart,
                    color: Colors.black,
                    size: 20,
                  )),
              TextSpan(
                  text: " 10k",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 12))
            ])),
        GestureDetector(
          onTap: () => index.showBottomSheet(
              context: context,
              builder: (scrollController) =>
                  CommentsPage(scrollController: scrollController)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: RichText(
                text: const TextSpan(children: [
              WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: PhosphorIcon(
                    PhosphorIconsBold.chatCircle,
                    color: Colors.black,
                    size: 20,
                  )),
              TextSpan(
                  text: " 2k",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 12))
            ])),
          ),
        ),
        GestureDetector(
          onTap: () => controller.sharePost(
              title: "Bài viết",
              url: "https://tcareer.thiendev.shop/home/detail/quang%20thien"),
          child: RichText(
              text: const TextSpan(children: [
            WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: PhosphorIcon(
                  PhosphorIconsBold.paperPlaneTilt,
                  color: Colors.black,
                  size: 20,
                )),
            TextSpan(
                text: " 200",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 12))
          ])),
        ),
      ],
    ),
  );
}