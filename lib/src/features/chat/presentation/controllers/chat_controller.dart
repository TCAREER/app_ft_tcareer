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
    // listenMessage();
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

  Future<void> enterPresence(String userId) async {
    await chatUseCase.enterPresence(
        conversationId: conversation?.conversationId.toString() ?? "",
        userId: userId);
  }

  Future<void> leavePresence(String userId) async {
    await chatUseCase.leavePresence(
        conversationId: conversation?.conversationId.toString() ?? "",
        userId: userId);
  }

  StreamSubscription<ably.PresenceMessage>? presenceSubscription;

  StreamSubscription<ably.PresenceMessage>? listenPresence(String userId) {
    presenceSubscription = chatUseCase.listenPresence(
        conversationId: conversation?.conversationId.toString() ?? "",
        handleChannelPresence: (presenceMessage) {
          print(">>>>>>>>>data: ${presenceMessage.data}");
          handleActivityState(presenceMessage, userId);
        });
    return presenceSubscription;
  }

  String? statusText;
  String status = "off";
  void handleActivityState(
      ably.PresenceMessage presenceMessage, String userId) {
    final presenceData = jsonDecode(presenceMessage.data.toString());
    print(">>>>>>>>>>>presenceData: $presenceData");
    if (presenceData['userId'] == userId) {
      status = presenceData['status'];
      print(">>>>>>status: ${presenceData['status']}");
      if (status == "online") {
        statusText = "Đang hoạt động";
      } else {
        String leavedAt =
            statusText = AppUtils.formatTimeMessage(presenceData['leavedAt']);
      }
    }
    notifyListeners();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    messageSubscription?.cancel();
    presenceSubscription?.cancel();
    scrollController.dispose();
    contentController.dispose();
  }

  bool hasContent = false;
  void setHasContent(String value) {
    if (value.isNotEmpty) {
      hasContent = true;
    } else {
      hasContent = false;
    }
    notifyListeners();
  }

  bool isShowEmoji = false;

  void setIsShowEmoJi(BuildContext context) {
    isShowEmoji = !isShowEmoji;
    if (isShowEmoji == true) {
      FocusScope.of(context).unfocus();
    } else {
      FocusScope.of(context).requestFocus();
    }
    notifyListeners();
  }

  bool isShowMedia = false;

  void setIsShowMedia(BuildContext context) {
    isShowMedia = !isShowMedia;
    if (isShowMedia == true) {
      FocusScope.of(context).unfocus();
    } else {
      FocusScope.of(context).requestFocus();
    }
    notifyListeners();
  }
}

final chatControllerProvider = ChangeNotifierProvider<ChatController>((ref) {
  final chatUseCase = ref.watch(chatUseCaseProvider);
  return ChatController(chatUseCase, ref);
});
