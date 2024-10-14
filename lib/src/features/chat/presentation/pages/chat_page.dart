import 'dart:io';
import 'package:app_tcareer/src/features/chat/presentation/controllers/chat_controller.dart';
import 'package:app_tcareer/src/features/chat/presentation/controllers/chat_media_controller.dart';
import 'package:app_tcareer/src/features/chat/presentation/pages/media/chat_media_page.dart';
import 'package:app_tcareer/src/features/chat/presentation/widgets/chat_input.dart';
import 'package:app_tcareer/src/features/chat/presentation/widgets/message_box.dart';
import 'package:app_tcareer/src/features/posts/presentation/posts_provider.dart';
import 'package:app_tcareer/src/features/user/presentation/controllers/user_controller.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
          controller.setHasContent("");
          if (controller.isShowEmoji == true) {
            controller.setIsShowEmoJi(context);
          }
          if (controller.isShowMedia == true) {
            controller.setIsShowMedia(context);
          }

          controller.contentController.clear();
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
            child: const Icon(Icons.arrow_back),
          ),
          title: Row(
            // crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(controller.user?.avatar ?? ""),
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    controller.user?.fullName ?? "",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Visibility(
                        visible: controller.status == "online",
                        child: const Icon(
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
                        style: const TextStyle(
                            color: Colors.black45, fontSize: 12),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
          actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.menu))],
        ),
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            messages(),
            if (controller.isShowMedia)
              DraggableScrollableSheet(
                expand: true,
                snap: true,
                initialChildSize: 0.4,
                maxChildSize: 1.0,
                minChildSize: 0.4,
                builder: (context, scrollController) {
                  return Container(
                    color: Colors.white,
                    child: ChatMediaPage(
                      scrollController: scrollController,
                    ), // Gọi trang media của bạn
                  );
                },
              ),
          ],
        ),
        bottomNavigationBar: Visibility(
            visible: !controller.isShowMedia,
            child: bottomAppBar(ref, context)),
      ),
    );
  }

  Widget bottomAppBar(WidgetRef ref, BuildContext context) {
    // final controller = ref.watch(commentControllerProvider);
    final media = ref.watch(chatMediaControllerProvider);

    final controller = ref.watch(chatControllerProvider);
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        // left: 5,
        // right: 5,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(
                horizontal: 8), // Thêm padding để tạo không gian
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment:
                  CrossAxisAlignment.center, // Đặt align cho Row
              children: [
                Expanded(
                  flex: 1,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          controller.setIsShowEmoJi(context);
                        },
                        child: const PhosphorIcon(
                          PhosphorIconsRegular.smiley,
                          color: Colors.grey,
                          size: 33,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: chatInput(
                    ref,
                    context,
                    onChanged: controller.setHasContent,
                    onTap: () {
                      if (controller.isShowEmoji == true) {
                        controller.setIsShowEmoJi(context);
                      }
                      if (controller.isShowMedia == true) {
                        controller.setIsShowMedia(context);
                      }
                    },
                  ),
                ),
                Visibility(
                  visible: controller.hasContent,
                  replacement: GestureDetector(
                    onTap: () async {
                      await media.getAlbums();
                      controller.setIsShowMedia(context);
                    },
                    child: const PhosphorIcon(
                      PhosphorIconsRegular.image,
                      color: Colors.grey,
                      size: 33,
                    ),
                  ),
                  child: GestureDetector(
                    onTap: () async => await controller.sendMessage(context),
                    child: Container(
                      padding: const EdgeInsets.all(
                          8), // Thêm padding để làm cho nút đẹp hơn
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          emoji(),
        ],
      ),
    );
  }

  Widget emoji() {
    final controller = ref.watch(chatControllerProvider);
    return Visibility(
      visible: controller.isShowEmoji,
      child: EmojiPicker(
        textEditingController: controller.contentController,
        onEmojiSelected: (category, emoji) {
          controller.setHasContent(emoji.toString());
        },
        onBackspacePressed: () {
          controller.setIsShowEmoJi(context);
        },
        config: const Config(
          height: 325,
          checkPlatformCompatibility: true,
          skinToneConfig: SkinToneConfig(),
          categoryViewConfig: CategoryViewConfig(),
          bottomActionBarConfig: BottomActionBarConfig(),
          searchViewConfig: SearchViewConfig(),
        ),
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5)
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
