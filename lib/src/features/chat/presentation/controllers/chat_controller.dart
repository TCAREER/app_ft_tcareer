import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:app_tcareer/src/configs/app_constants.dart';
import 'package:app_tcareer/src/features/chat/data/models/all_conversation.dart';
import 'package:app_tcareer/src/features/chat/data/models/conversation.dart';
import 'package:app_tcareer/src/features/chat/data/models/leave_chat_request.dart';
import 'package:app_tcareer/src/features/chat/data/models/mark_read_message_request.dart';
import 'package:app_tcareer/src/features/chat/data/models/message.dart';
import 'package:app_tcareer/src/features/chat/data/models/send_message_request.dart';
import 'package:app_tcareer/src/features/chat/data/models/user.dart';
import 'package:app_tcareer/src/features/chat/data/models/user_conversation.dart';
import 'package:app_tcareer/src/features/chat/presentation/controllers/chat_media_controller.dart';
import 'package:app_tcareer/src/features/chat/presentation/controllers/conversation_controller.dart';
import 'package:app_tcareer/src/features/chat/presentation/pages/media/chat_media_page.dart';
import 'package:app_tcareer/src/features/chat/usecases/chat_use_case.dart';
import 'package:app_tcareer/src/features/user/presentation/controllers/user_controller.dart';
import 'package:app_tcareer/src/utils/app_utils.dart';
import 'package:app_tcareer/src/utils/snackbar_utils.dart';
import 'package:app_tcareer/src/utils/user_utils.dart';
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
    // await chatUseCase.publishMessage(
    //
    //     data: {"message": contentController.text, "userId": "1"});
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
      statusText = AppUtils.formatTimeMessage(user?.leftAt.toString() ?? "");
      _startTimer(user?.leftAt.toString() ?? "");
      notifyListeners();
    }
  }

  Future<void> sendMessage(BuildContext context) async {
    AppUtils.futureApi(() async {
      final body = SendMessageRequest(
        conversationId: conversationData?.conversation?.id,
        content: contentController.text,
      );
      await chatUseCase.sendMessage(body).then((val) {
        contentController.clear();
        setHasContent("");
      });
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
    if (messageData['status'] == "read") {
      print(">>>>>>>>>>>1");
      final currentMessage = messages.first;
      final updatedMessage = currentMessage.copyWith(status: "read");
      messages[0] = updatedMessage;
      notifyListeners();
    } else {
      print(">>>>>>>>2");
      final mediaUrls = messageData['media_url'] != null
          ? List<String>.from(messageData['media_url'])
          : <String>[];

      final newMessage = MessageModel(
        mediaUrl: mediaUrls,
        content: messageData['content'],
        conversationId: conversationData?.conversation?.id,
        id: messageData['message_id'],
        senderId: messageData['sender_id'],
        status: "sent",
        createdAt:
            messageData['created_at'], // sửa 'createdAt' thành 'created_at'
      );
      final conversationController = ref.read(conversationControllerProvider);
      conversationController.updateLastMessage(
          senderId: messageData['sender_id'].toString(),
          messageData: messageData);
      notifyListeners();
      // Kiểm tra xem message có tồn tại trong messages hay không
      if (!messages
          .any((existingMessage) => existingMessage.id == newMessage.id)) {
        messages.removeWhere((message) => message.type == "temp");
        messages.insert(0, newMessage);

        markMessageAsRead(
            senderId: messageData['sender_id'].toString(),
            userId: user?.userId.toString() ?? "",
            messageId: messageData['message_id']);

        notifyListeners();
      }
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

  Future<void> markMessageAsRead(
      {required String senderId,
      required String userId,
      required dynamic messageId}) async {
    final userUtil = ref.watch(userUtilsProvider);
    String clientId = await userUtil.getUserId();

    if (clientId != senderId && messages.first.status == "sent") {
      String data = jsonEncode(
          {"topic": "statusMessage", "id": messageId, "status": "read"});
      await chatUseCase.postMarkReadMessage(MarkReadMessageRequest(
        conversationId: conversationData?.conversation?.id,
      ));
      await chatUseCase
          .publishMessage(
              conversationId:
                  conversationData?.conversation?.id.toString() ?? "",
              data: data)
          .then((val) async {});
    }
  }

  Future<void> leavePresence(String userId) async {
    await chatUseCase.leavePresence(
        conversationId: conversationData?.conversation?.id.toString() ?? "",
        userId: userId);
    await chatUseCase.putLeavedChat(LeaveChatRequest(
        conversationId: conversationData?.conversation?.id,
        time: DateTime.now().toIso8601String()));
    // statusText = null;
    // status = "off";
  }

  Future<void> markReadMessage() async {
    await chatUseCase.postMarkReadMessage(MarkReadMessageRequest(
      conversationId: conversationData?.conversation?.id,
    ));
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
  Timer? _timer;

  void handleActivityState(
      ably.PresenceMessage presenceMessage, String userId) {
    final presenceData = jsonDecode(presenceMessage.data.toString());
    print(">>>>>>>>>>>presenceData: $presenceData");
    if (presenceData['userId'] == userId) {
      status = presenceData['status'];
      print(">>>>>>status: ${presenceData['status']}");
      if (status == "online") {
        statusText = "Đang hoạt động";
        _cancelTimer();
      } else {
        statusText = AppUtils.formatTimeMessage(presenceData['leavedAt']);
        _startTimer(presenceData['leavedAt']);
      }
    }
    notifyListeners();
  }

  void _startTimer(String dateString) {
    _cancelTimer();
    _timer = Timer.periodic(Duration(minutes: 1), (_) {
      statusText = AppUtils.formatTimeMessage(dateString);
      notifyListeners();
    });
  }

  void _cancelTimer() {
    _timer?.cancel(); // Hủy Timer nếu nó đang chạy
    _timer = null;
  }

  Future<void> disposeService() async => await chatUseCase.disconnect();
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
    if (isShowMedia == true) {
      setIsShowMedia(context);
    }

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
    if (isShowEmoji == true) {
      setIsShowEmoJi(context);
    }
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

  Future<void> onInit(
      {required String clientId, required String userId}) async {
    // isShowMedia = false;
    // isShowEmoji = false;
    // contentController.clear();
    // hasContent = false;
    await getConversation(userId);
    await initializeAbly();
    await enterPresence(clientId);
    if (messages.isNotEmpty && messages[0].status == "sent") {
      await markMessageAsRead(
          senderId: messages.first.senderId.toString(),
          userId: userId,
          messageId: messages.first.id);
    }
    // listenPresence(userId);
    // listenMessage();
  }
}

final chatControllerProvider = ChangeNotifierProvider<ChatController>((ref) {
  final chatUseCase = ref.watch(chatUseCaseProvider);
  return ChatController(chatUseCase, ref);
});
