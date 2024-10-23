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
import 'package:ably_flutter/ably_flutter.dart' as ably;

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
      await controller.getFriends();
      await controller.getAllConversation();
    });

    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   await ref.read(conversationControllerProvider).getAllConversation();
    // });
  }

  // @override
  // void dispose() {
  //   final controller = ref.read(conversationControllerProvider);
  //   controller.dispose();
  //   super.dispose();
  // }
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    Future.microtask(() async {
      final controller = ref.read(conversationControllerProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(conversationControllerProvider);
    // Future.microtask(() async {
    //
    // });
    // Future.microtask(() async {
    //   await controller.onInit();
    // });
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
            sliverFriend(),
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
                  leading: Stack(
                    children: [
                      // Avatar
                      CircleAvatar(
                        radius: 20,
                        backgroundImage:
                            NetworkImage(conversation.userAvatar ?? ""),
                      ),
                      // Chấm tròn cắt vào avatar
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: StreamBuilder<Map<dynamic, dynamic>>(
                          stream: controller.listenUsersStatus(
                              conversation.userId.toString()),
                          builder: (context, snapshot) {
                            return Visibility(
                              visible: snapshot.data?['status'] == "online",
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
                            );
                          },
                        ),
                      ),
                    ],
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
    final userUtils = ref.watch(userUtilsProvider);
    final controller = ref.watch(conversationControllerProvider);
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: controller.friends.length,
            itemBuilder: (context, index) {
              final friend = controller.friends[index];
              return GestureDetector(
                onTap: () async {
                  String clientId = await userUtils.getUserId();
                  context.goNamed("chat", pathParameters: {
                    "userId": friend.id.toString() ?? "",
                    "clientId": clientId
                  });
                },
                child: Container(
                  width: 70, // Đặt chiều rộng cho mỗi avatar
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          // Avatar
                          CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(friend.avatar ?? ""),
                          ),
                          // Chấm tròn cắt vào avatar
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: StreamBuilder<Map<dynamic, dynamic>>(
                              stream: controller
                                  .listenUsersStatus(friend.id.toString()),
                              builder: (context, snapshot) {
                                return Visibility(
                                  visible: snapshot.data?['status'] == "online",
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
                                );
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 5),
                      Text(
                        friend.lastName ?? "",
                        overflow: TextOverflow.ellipsis,
                      ), // Thay đổi tên người bạn
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
