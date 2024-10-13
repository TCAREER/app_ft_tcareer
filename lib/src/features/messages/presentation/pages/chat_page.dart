import 'dart:io';

import 'package:app_tcareer/src/features/messages/presentation/widgets/chat_input.dart';
import 'package:app_tcareer/src/features/messages/presentation/widgets/message_box.dart';
import 'package:app_tcareer/src/features/posts/presentation/posts_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ChatPage extends ConsumerWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      extendBody: true,

      // resizeToAvoidBottomInset: true,
      // backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        leadingWidth: 40,
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: Icon(Icons.arrow_back),
        ),
        title: const Row(
          // crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(
                  "https://mighty.tools/mockmind-api/content/human/41.jpg"),
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Nguyễn Văn A",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.circle,
                      color: Colors.green,
                      size: 8,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      "Đang hoạt động",
                      style: TextStyle(color: Colors.green, fontSize: 12),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.menu))],
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.end,
        children: [
          messages(),
          bottomAppBar(ref, context),
        ],
      ),
    );
  }

  Widget bottomAppBar(WidgetRef ref, BuildContext context) {
    // final controller = ref.watch(commentControllerProvider);
    final mediaController = ref.watch(mediaControllerProvider);
    final hasAsset = mediaController.imagePaths.isNotEmpty ||
        mediaController.videoThumbnail != null;
    final imagesPath = mediaController.imagePaths;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Visibility(
            visible: hasAsset,
            child: Visibility(
              visible: mediaController.imagePaths.isNotEmpty,
              replacement: Padding(
                padding: const EdgeInsets.only(right: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(mediaController.videoThumbnail ?? ""),
                        height: 60,
                        width: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: IconButton(
                          onPressed: () => mediaController.removeAssets(),
                          icon: PhosphorIcon(PhosphorIconsBold.xCircle)),
                    )
                  ],
                ),
              ),
              child: Wrap(
                children: imagesPath.map((image) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            File(image),
                            height: 60,
                            width: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: IconButton(
                              onPressed: () => mediaController.removeAssets(),
                              icon: PhosphorIcon(PhosphorIconsBold.xCircle)),
                        )
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(
                vertical: 8), // Thêm padding để tạo không gian
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end, // Đặt align cho Row
              children: [
                Visibility(
                  visible: !hasAsset,
                  child: Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () async {
                            await mediaController.getAlbums();
                            context.pushNamed("photoManager",
                                queryParameters: {"isComment": "true"});
                          },
                          icon: const PhosphorIcon(
                            PhosphorIconsBold.camera,
                            color: Colors.grey,
                            size: 30,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: chatInput(ref, context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget messages() {
    List<Map<String, dynamic>> chatMessages = [
      {
        'message': 'Chào bạn! Bạn có khỏe không?',
        'isMe': false,
        'createdAt': '10:30 AM',
      },
      {
        'message': 'Mình khỏe, cảm ơn! Còn bạn thì sao?',
        'isMe': true,
        'createdAt': '10:32 AM',
      },
      {
        'message': 'Mình cũng khỏe, cảm ơn bạn đã hỏi!',
        'isMe': false,
        'createdAt': '10:34 AM',
      },
      {
        'message': 'Hôm nay bạn có rảnh không? Muốn gặp bạn.',
        'isMe': true,
        'createdAt': '10:35 AM',
      },
      {
        'message': 'Tất nhiên rồi! Mình có thể gặp bạn vào chiều nay.',
        'isMe': false,
        'createdAt': '10:36 AM',
      },
    ];

    return Expanded(
        child: ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      itemCount: chatMessages.length,
      itemBuilder: (context, index) {
        final chat = chatMessages[index];
        return messageBox(
            message: chat['message'],
            isMe: chat['isMe'],
            createdAt: chat['createdAt']);
      },
      separatorBuilder: (context, index) => const SizedBox(
        height: 20,
      ),
    ));
  }
}
