import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:app_tcareer/src/configs/app_constants.dart';
import 'package:app_tcareer/src/features/chat/data/models/conversation.dart';
import 'package:app_tcareer/src/features/chat/data/models/message.dart';
import 'package:app_tcareer/src/features/chat/data/models/send_message_request.dart';
import 'package:app_tcareer/src/features/chat/data/models/user.dart';
import 'package:app_tcareer/src/features/chat/data/models/user_conversation.dart';
import 'package:app_tcareer/src/features/chat/presentation/controllers/chat_media_controller.dart';
import 'package:app_tcareer/src/features/chat/presentation/pages/media/chat_media_page.dart';
import 'package:app_tcareer/src/features/chat/usecases/chat_use_case.dart';
import 'package:app_tcareer/src/features/user/presentation/controllers/user_controller.dart';
import 'package:app_tcareer/src/utils/app_utils.dart';
import 'package:app_tcareer/src/utils/snackbar_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ably_flutter/ably_flutter.dart' as ably;
import 'package:photo_manager/photo_manager.dart';
import 'package:uuid/uuid.dart';

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

  Conversation? conversationData;
  UserConversation? user;
  List<MessageModel> messages = [];
  String? cachedUserId; // Lưu trữ userId để sử dụng lại

  Future<void> getConversation(String userId) async {
    // if (cachedUserId != userId) {
    //   // Kiểm tra nếu userId đã thay đổi
    //   cachedUserId = userId; // Lưu trữ userId
    messages.clear();
    conversationData = await chatUseCase.getConversation(userId);

    if (conversationData != null) {
      user = conversationData?.conversation;
      final newConversations = conversationData?.message?.data
          ?.where((newConversation) =>
              !messages.any((messages) => messages.id == newConversation.id))
          .toList();
      messages.addAll(newConversations?.reversed ?? []);
      notifyListeners();
    }
  }

  Future<void> sendMessage(BuildContext context) async {
    AppUtils.futureApi(() async {
      final body = SendMessageRequest(
        conversationId: conversationData?.conversation?.id,
        content: contentController.text,
      );
      await chatUseCase.sendMessage(body);

      contentController.clear();
      setHasContent("");
    }, context, (val) {});
  }

  Future<void> initializeAbly() async => await chatUseCase.initialize();
  StreamSubscription<ably.Message>? messageSubscription;

  StreamSubscription<ably.Message>? listenMessage() {
    // Hủy bỏ subscription cũ nếu có
    // messageSubscription?.cancel();

    messageSubscription = chatUseCase.listenAllMessage(
      conversationId: conversationData?.conversation?.id.toString() ?? "",
      handleChannelMessage: (message) {
        print(">>>>>>>>data: ${message.data}");
        handleUpdateMessage(message);
      },
    );

    return messageSubscription;
  }

  void handleUpdateMessage(ably.Message message) {
    final messageData = jsonDecode(message.data.toString());
    final mediaUrls = messageData['media_url'] != null
        ? List<String>.from(messageData['media_url'])
        : <String>[];

    final newMessage = MessageModel(
      mediaUrl: mediaUrls,
      content: messageData['content'],
      conversationId: conversationData?.conversation?.id,
      id: messageData['message_id'],
      senderId: messageData['sender_id'],
      createdAt:
          messageData['created_at'], // sửa 'createdAt' thành 'created_at'
    );
    messages.removeWhere((message) => message.type == "temp");
    notifyListeners();
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
        conversationId: conversationData?.conversation?.id.toString() ?? "",
        userId: userId);
  }

  Future<void> leavePresence(String userId) async {
    await chatUseCase.leavePresence(
        conversationId: conversationData?.conversation?.id.toString() ?? "",
        userId: userId);
  }

  StreamSubscription<ably.PresenceMessage>? presenceSubscription;

  StreamSubscription<ably.PresenceMessage>? listenPresence(String userId) {
    presenceSubscription = chatUseCase.listenPresence(
        conversationId: conversationData?.conversation?.id.toString() ?? "",
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

  Future<void> disposeService() async => await chatUseCase.dispose();
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

  Future<void> setIsShowMedia(BuildContext context) async {
    isShowMedia = !isShowMedia;
    if (isShowMedia == true) {
      FocusScope.of(context).unfocus();
    } else {
      FocusScope.of(context).requestFocus();
    }
    notifyListeners();
  }

  Future<void> sendMessageWithMedia(List<String> mediaUrl) async {
    // await mediaController.getAssetPaths(context);
    // print(">>>>>>>image: ${mediaController.imagePaths}");
    // notifyListeners();

    // if (mediaController.imagePaths.isNotEmpty) {
    //   await mediaController.uploadImage();

    final body = SendMessageRequest(
        conversationId: conversationData?.conversation?.id, mediaUrl: mediaUrl);
    await chatUseCase.sendMessage(body);
    // notifyListeners();

    // setIsShowMedia(context);
  }

  // Future<void> showMediaPage(BuildContext context) async {
  //   await showModalBottomSheet(
  //       isScrollControlled: true,
  //       useRootNavigator: true,
  //       context: context,
  //       builder: (context) => DraggableScrollableSheet(
  //             expand: true,
  //             snap: true,
  //             initialChildSize: 0.4,
  //             maxChildSize: 1.0,
  //             minChildSize: 0.4,
  //             builder: (context, scrollController) {
  //               return Container(
  //                 color: Colors.white,
  //                 child: ChatMediaPage(
  //                   scrollController: scrollController,
  //                 ),
  //               );
  //             },
  //           ));
  // }
}

final chatControllerProvider = ChangeNotifierProvider<ChatController>((ref) {
  final chatUseCase = ref.watch(chatUseCaseProvider);
  return ChatController(chatUseCase, ref);
});
