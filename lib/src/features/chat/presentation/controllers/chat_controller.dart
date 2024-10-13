import 'dart:async';
import 'dart:convert';

import 'package:app_tcareer/src/configs/app_constants.dart';
import 'package:app_tcareer/src/features/chat/data/models/conversation.dart';
import 'package:app_tcareer/src/features/chat/data/models/message.dart';
import 'package:app_tcareer/src/features/chat/data/models/send_message_request.dart';
import 'package:app_tcareer/src/features/chat/data/models/user.dart';
import 'package:app_tcareer/src/features/chat/usecases/chat_use_case.dart';
import 'package:app_tcareer/src/features/user/presentation/controllers/user_controller.dart';
import 'package:app_tcareer/src/utils/app_utils.dart';
import 'package:app_tcareer/src/utils/snackbar_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ably_flutter/ably_flutter.dart' as ably;

class ChatController extends ChangeNotifier {
  final ChatUseCase chatUseCase;
  final Ref ref;

  ChatController(this.chatUseCase, this.ref) {
    listenMessage();
  }

  ScrollController scrollController = ScrollController();

  TextEditingController contentController = TextEditingController();
  Future<void> publishMessage() async {
    final userController = ref.watch(userControllerProvider);
    final user = userController.userData?.data;
    await chatUseCase.publishMessage(
        name: user?.fullName ?? "",
        data: {"message": contentController.text, "userId": "1"});
  }

  Conversation? conversation;
  UserModel? user;
  List<MessageModel> messages = [];
  Future<void> getConversation(String userId) async {
    messages.clear();
    conversation = await chatUseCase.getConversation(userId);
    if (conversation != null) {
      user = conversation?.user;
      final newConversations = conversation?.message?.data
          ?.where((newConversation) =>
              !messages.any((messages) => messages.id == newConversation.id))
          .toList();
      messages.addAll(newConversations?.reversed ?? []);
      notifyListeners();

      // WidgetsBinding.instance.addPostFrameCallback((_) {
      //   scrollToBottom();
      // });
    }
  }

  Future<void> sendMessage(BuildContext context) async {
    AppUtils.futureApi(() async {
      final body = SendMessageRequest(
        conversationId: conversation?.conversationId,
        content: contentController.text,
      );
      await chatUseCase.sendMessage(body);

      contentController.clear();

      notifyListeners();
    }, context, (val) {});
  }

  StreamSubscription<ably.Message>? messageSubscription;

  StreamSubscription<ably.Message>? listenMessage() {
    // Hủy bỏ subscription cũ nếu có
    // messageSubscription?.cancel();

    messageSubscription = chatUseCase.listenAllMessage(
      conversationId: conversation?.conversationId.toString() ?? "",
      handleChannelMessage: (message) {
        print(">>>>>>>>data: ${message.data}");
        handleUpdateMessage(message);
      },
    );

    return messageSubscription;
  }

  void handleUpdateMessage(ably.Message message) {
    final messageData = jsonDecode(message.data.toString());
    final newMessage = MessageModel(
      content: messageData['content'],
      conversationId: conversation?.conversationId,
      id: messageData['message_id'],
      senderId: messageData['sender_id'],
      createdAt:
          messageData['created_at'], // sửa 'createdAt' thành 'created_at'
    );

    // Kiểm tra xem message có tồn tại trong messages hay không
    if (!messages
        .any((existingMessage) => existingMessage.id == newMessage.id)) {
      messages.insert(0, newMessage);
      notifyListeners();
    }
  }

  void scrollToBottom() {
    final position = scrollController.position.maxScrollExtent;
    scrollController.jumpTo(position);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    messageSubscription?.cancel();
    scrollController.dispose();
  }
}

final chatControllerProvider = ChangeNotifierProvider<ChatController>((ref) {
  final chatUseCase = ref.watch(chatUseCaseProvider);

  return ChatController(chatUseCase, ref);
});
