import 'dart:io';
import 'package:app_tcareer/src/features/chat/presentation/controllers/chat_controller.dart';
import 'package:app_tcareer/src/features/chat/presentation/widgets/chat_input.dart';
import 'package:app_tcareer/src/features/chat/presentation/widgets/message_box.dart';
import 'package:app_tcareer/src/features/posts/presentation/posts_provider.dart';
import 'package:app_tcareer/src/features/user/presentation/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ChatPage extends ConsumerStatefulWidget {
  final String userId;
  final String clientId;
  const ChatPage({super.key, required this.userId, required this.clientId});

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  @override
  void initState() {
    // TODO: implement initState
    Future.microtask(() async {
      await ref.read(chatControllerProvider).getConversation(widget.userId);
      // ref.watch(chatControllerProvider).scrollToBottom();
      await ref.read(chatControllerProvider).enterPresence(widget.clientId);
      ref.read(chatControllerProvider).listenPresence(widget.userId);
      ref.read(chatControllerProvider).listenMessage();
    });

    super.initState();
  }

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   Future.microtask(() async {
  //     await ref.read(chatControllerProvider).leavePresence(widget.userId);
  //   });
  //   super.dispose();
  // }
  // @override
  // void didChangeDependencies() {
  //   // TODO: implement didChangeDependencies
  //   super.didChangeDependencies();
  //   // WidgetsBinding.instance.addPostFrameCallback((_) {
  //   //   ref.read(chatControllerProvider).scrollToBottom();
  //   // });
  // }

  @override
  Widget build(
    BuildContext context,
  ) {
    final controller = ref.watch(chatControllerProvider);

    return PopScope(
      onPopInvoked: (didPop) async {
        if (didPop) {
          await controller.leavePresence(widget.clientId);
        }
      },
      child: Scaffold(
        // extendBody: true,

        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: false,
          leadingWidth: 40,
          leading: GestureDetector(
            onTap: () => context.pop(),
            child: Icon(Icons.arrow_back),
          ),
          title: Row(
            // crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(controller.user?.avatar ?? ""),
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    controller.user?.fullName ?? "",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Visibility(
                        visible: controller.status == "online",
                        child: Icon(
                          Icons.circle,
                          color: Colors.green,
                          size: 8,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        controller.statusText ?? "",
                        style: TextStyle(color: Colors.black45, fontSize: 12),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
          actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.menu))],
        ),
        body: messages(),
        bottomNavigationBar: bottomAppBar(ref, context),
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
      padding: EdgeInsets.only(
        bottom:
            MediaQuery.of(context).viewInsets.bottom, // Tránh tràn với bàn phím
        left: 5,
        right: 5,
        top: 5,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
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
    final controller = ref.watch(chatControllerProvider);
    final user = ref.watch(userControllerProvider);
    final messages = controller.messages;

    return ListView.separated(
      reverse: true,
      controller: controller.scrollController,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5)
          .copyWith(bottom: 80),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        bool isMe = message.senderId == user.userData?.data?.id;
        return messageBox(
            message: message.content ?? "",
            isMe: isMe,
            createdAt: message.createdAt ?? "");
      },
      separatorBuilder: (context, index) => const SizedBox(
        height: 20,
      ),
    );
  }
}
