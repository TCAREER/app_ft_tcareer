import 'dart:io';

import 'package:app_tcareer/src/extensions/image_extension.dart';
import 'package:app_tcareer/src/features/chat/presentation/controllers/chat_controller.dart';
import 'package:app_tcareer/src/features/chat/presentation/controllers/chat_media_controller.dart';
import 'package:app_tcareer/src/utils/app_utils.dart';
import 'package:app_tcareer/src/widgets/cached_image_widget.dart';
import 'package:app_tcareer/src/widgets/circular_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fb_photo_view/flutter_fb_photo_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget messageBox({
  required String message,
  bool isMe = false,
  required String createdAt,
  required WidgetRef ref,
  required List<String> media,
}) {
  print(">>>>>>>>media: $media");
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: !isMe ? MainAxisAlignment.start : MainAxisAlignment.end,
    children: [
      Visibility(
        visible: !isMe,
        child: const CircleAvatar(
          radius: 15,
          backgroundImage: NetworkImage(
              "https://mighty.tools/mockmind-api/content/human/41.jpg"),
        ),
      ),
      const SizedBox(
        width: 10,
      ),
      Visibility(
        visible: message != "",
        child: Expanded(
          child: Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              ConstrainedBox(
                constraints:
                    BoxConstraints(maxWidth: ScreenUtil().screenWidth * .7),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 5),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                      color: isMe ? const Color(0xff3E66FB) : Colors.white,
                      borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message,
                        style: TextStyle(
                            color: isMe ? Colors.white : Colors.black,
                            fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        AppUtils.formatCreatedAt(createdAt),
                        style: TextStyle(
                            color: isMe ? Colors.white : Colors.black54,
                            fontSize: 11,
                            fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      Visibility(
          visible: media.isNotEmpty,
          child: Expanded(
            child: Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                ConstrainedBox(
                    constraints:
                        BoxConstraints(maxWidth: ScreenUtil().screenWidth * .6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        mediaItem(media, ref),
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(16)),
                          child: Text(
                            AppUtils.formatCreatedAt(createdAt),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                      ],
                    )),
              ],
            ),
          ))
    ],
  );
}

Widget mediaItem(List<String> media, WidgetRef ref) {
  if (media.length == 1) {
    return Visibility(
      visible: media[0].isImageNetWork,
      replacement: Stack(
        alignment: Alignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken),
              child: Image.file(
                File(media[0]),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(
              width: 24, // Kích thước của indicator
              height: 24,
              child: circularLoadingWidget()),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: cachedImageWidget(
          visiblePlaceHolder: false,
          imageUrl: media[0],
          fit: BoxFit.cover,
        ),
      ),
    );
  } else {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        childAspectRatio: 0.5,
      ),
      itemCount: media.length,
      itemBuilder: (context, index) {
        return Visibility(
          visible: media[index].isImageNetWork,
          replacement: Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: ColorFiltered(
                  colorFilter:
                      ColorFilter.mode(Colors.black54, BlendMode.darken),
                  child: Image.file(
                    File(media[index]),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(
                  width: 24, // Kích thước của indicator
                  height: 24,
                  child: circularLoadingWidget()),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: cachedImageWidget(
              visiblePlaceHolder: false,
              imageUrl: media[index],
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }
}
