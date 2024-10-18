import 'dart:io';
import 'package:app_tcareer/src/features/chat/presentation/controllers/chat_controller.dart';
import 'package:app_tcareer/src/features/chat/presentation/controllers/chat_media_controller.dart';
import 'package:app_tcareer/src/features/chat/presentation/pages/media/chat_media_page.dart';
import 'package:app_tcareer/src/features/chat/presentation/widgets/chat_bottom_app_bar.dart';
import 'package:app_tcareer/src/features/chat/presentation/widgets/chat_emoji.dart';
import 'package:app_tcareer/src/features/chat/presentation/widgets/chat_input.dart';
import 'package:app_tcareer/src/features/chat/presentation/widgets/message_box.dart';
import 'package:app_tcareer/src/features/posts/presentation/posts_provider.dart';
import 'package:app_tcareer/src/features/user/presentation/controllers/user_controller.dart';
import 'package:app_tcareer/src/utils/app_utils.dart';
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
  final DraggableScrollableController draggableScrollableController =
      DraggableScrollableController();
  @override
  void initState() {
    // TODO: implement initState
    Future.microtask(() async {
      final controller = ref.read(chatControllerProvider);
      await controller.getConversation(widget.userId);
      // ref.watch(chatControllerProvider).scrollToBottom();
      await controller.initializeAbly();
      await controller.enterPresence(widget.clientId);
      controller.listenPresence(widget.userId);
      controller.listenMessage();
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
            await controller.disposeService();
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
          extendBody: true,

          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.grey.shade100,
          appBar: appBar(ref),

          body: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  messages(),
                ],
              ),
              if (controller.isShowMedia)
                DraggableScrollableSheet(
                  controller: draggableScrollableController,
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
                        draggableScrollableController:
                            draggableScrollableController,
                      ), // Gọi trang media của bạn
                    );
                  },
                ),
              Visibility(
                  visible: !controller.isShowMedia,
                  child: chatBottomAppBar(ref, context)),
            ],
          ),

          // bottomNavigationBar:
        ));
  }

  Widget messages() {
    final controller = ref.watch(chatControllerProvider);
    final user = ref.watch(userControllerProvider);
    final mediaController = ref.watch(chatMediaControllerProvider);
    final messages = controller.messages;

    return Expanded(
      // flex: 5,
      child: ListView.separated(
        reverse: true,
        controller: controller.scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 10).copyWith(
            bottom: controller.isShowMedia
                ? ScreenUtil().screenHeight * .37
                : controller.isShowEmoji
                    ? ScreenUtil().screenHeight * .4
                    : 60,
            top: 5),
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final message = messages[index];
          bool isMe = message.senderId == user.userData?.data?.id;
          return messageBox(
              avatarUrl: controller.user?.userAvatar ?? "",
              media: message.mediaUrl ?? [],
              ref: ref,
              message: message.content ?? "",
              isMe: isMe,
              createdAt: message.createdAt ?? "");
        },
        separatorBuilder: (context, index) => const SizedBox(
          height: 2,
        ),
      ),
    );
  }

  PreferredSize appBar(WidgetRef ref) {
    final controller = ref.watch(chatControllerProvider);

    return PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
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
              Visibility(
                  visible: controller.status == "online" ||
                      controller.statusText == "Đang hoạt động",
                  replacement: CircleAvatar(
                    radius: 20,
                    backgroundImage:
                        NetworkImage(controller.user?.userAvatar ?? ""),
                  ),
                  child: Stack(
                    children: [
                      // Avatar
                      CircleAvatar(
                        radius: 20,
                        backgroundImage:
                            NetworkImage(controller.user?.userAvatar ?? ""),
                      ),
                      // Chấm tròn cắt vào avatar
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 12, // Độ rộng của chấm tròn
                          height: 12, // Chiều cao của chấm tròn
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.green, // Màu của chấm tròn
                            border: Border.all(
                              color: Colors
                                  .white, // Đường viền màu trắng để tạo hiệu ứng cắt vào avatar
                              width: 2, // Độ dày của viền
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    controller.user?.userFullName ?? "",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Visibility(
                      //   visible: controller.status == "online" ||
                      //       controller.statusText == "Đang hoạt động",
                      //   child: const Icon(
                      //     Icons.circle,
                      //     color: Colors.green,
                      //     size: 8,
                      //   ),
                      // ),
                      // Visibility(
                      //   visible: controller.status == "online" ||
                      //       controller.statusText == "Đang hoạt động",
                      //   child: const SizedBox(
                      //     width: 5,
                      //   ),
                      // ),
                      Text(
                        controller.statusText ?? "",
                        // AppUtils.formatTimeMessage(controller.user?.leftAt),
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
        ));
  }
}