import 'package:app_tcareer/src/features/chat/presentation/controllers/chat_controller.dart';
import 'package:app_tcareer/src/features/chat/presentation/controllers/conversation_controller.dart';
import 'package:app_tcareer/src/features/posts/presentation/widgets/empty_widget.dart';
import 'package:app_tcareer/src/features/user/usercases/connection_use_case.dart';
import 'package:app_tcareer/src/utils/app_utils.dart';
import 'package:app_tcareer/src/utils/user_utils.dart';
import 'package:app_tcareer/src/widgets/circular_loading_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ConversationPage extends ConsumerStatefulWidget {
  const ConversationPage({super.key});

  @override
  ConsumerState<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends ConsumerState<ConversationPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() async {
      final controller = ref.read(conversationControllerProvider);
      await controller.initializeAbly();
      controller.listenAllConversation();
    });
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   await ref.read(conversationControllerProvider).getAllConversation();
    // });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(conversationControllerProvider);
    Future.microtask(() async {
      await controller.onInit();
    });
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            CupertinoSliverRefreshControl(
              onRefresh: () async => await controller.getAllConversation(),
            ),
            sliverAppBar(context),
            sliverChat(),
          ],
        ),
      ),
    );
  }

  Widget sliverAppBar(BuildContext context) {
    // final postingController = ref.watch(postingControllerProvider);
    return SliverAppBar(
      centerTitle: false,
      backgroundColor: Colors.white,
      floating: true,
      pinned: false, // AppBar không cố định
      title: const Text(
        "Tin nhắn",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
      ),
      // leadingWidth: 120,
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: GestureDetector(
            onTap: () {},
            child: const PhosphorIcon(
              PhosphorIconsRegular.magnifyingGlass,
              color: Colors.black,
              size: 20,
            ),
          ),
        ),
      ],
      // bottom: PreferredSize(
      //   preferredSize: postingController.isLoading == true
      //       ? const Size.fromHeight(30)
      //       : const Size.fromHeight(0),
      //   child: postingLoading(ref),
      // ),
    );
  }

  Widget sliverChat() {
    final controller = ref.watch(conversationControllerProvider);
    final userUtils = ref.watch(userUtilsProvider);
    return SliverPadding(
      padding: const EdgeInsets.only(bottom: 550),
      sliver: SliverVisibility(
          visible: controller.allConversation != null,
          replacementSliver: SliverToBoxAdapter(
            child: circularLoadingWidget(),
          ),
          sliver: SliverVisibility(
            visible: controller.conversations.isNotEmpty == true,
            replacementSliver: SliverToBoxAdapter(
              child: emptyWidget("Bạn chưa có đoạn chat nào!"),
            ),
            sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
              childCount: controller.conversations.length,
              (context, index) {
                final conversation = controller.conversations[index];

                return ListTile(
                  onTap: () async {
                    String clientId = await userUtils.getUserId();
                    context.goNamed("chat", pathParameters: {
                      "userId": conversation.userId.toString() ?? "",
                      "clientId": clientId
                    });
                    print(
                        ">>>>>>>>>>>>conversations: ${controller.conversations}");
                  },
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundImage:
                        NetworkImage(conversation.userAvatar ?? ""),
                  ),
                  title: Text(conversation.userFullName ?? ""),
                  subtitle: Text(
                    conversation.latestMessage ?? "",
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                  trailing: Text(AppUtils.formatTimeLastMessage(
                      conversation.updatedAt ?? "")),
                );
              },
            )),
          )),
    );
  }

  Widget sliverFriend() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: SizedBox(
          height: 100, // Đặt chiều cao cho hàng bạn bè
          child: ListView.builder(
            scrollDirection: Axis.horizontal, // Cuộn theo chiều ngang
            itemCount: 5,
            itemBuilder: (context, index) {
              return Container(
                width: 70, // Đặt chiều rộng cho mỗi avatar
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(
                          "https://mighty.tools/mockmind-api/content/human/57.jpg"),
                    ),
                    const SizedBox(height: 5),
                    Text("Bạn $index"), // Thay đổi tên người bạn
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
