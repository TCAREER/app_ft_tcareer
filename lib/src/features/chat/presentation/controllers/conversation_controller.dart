import 'dart:async';
import 'dart:convert';
import 'package:ably_flutter/ably_flutter.dart' as ably;
import 'package:app_tcareer/src/features/chat/data/models/all_conversation.dart';
import 'package:app_tcareer/src/features/chat/data/models/mark_read_message_request.dart';
import 'package:app_tcareer/src/features/chat/data/models/user_conversation.dart';
import 'package:app_tcareer/src/features/chat/presentation/controllers/chat_controller.dart';
import 'package:app_tcareer/src/features/chat/usecases/chat_use_case.dart';
import 'package:app_tcareer/src/features/user/data/models/users.dart';
import 'package:app_tcareer/src/features/user/usercases/user_use_case.dart';
import 'package:app_tcareer/src/utils/user_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConversationController extends ChangeNotifier {
  final ChatUseCase chatUseCase;
  final Ref ref;

  ConversationController(this.chatUseCase, this.ref);

  AllConversation? allConversation;
  List<UserConversation> conversations = [];
  Future<void> getAllConversation() async {
    allConversation = null;
    conversations.clear();
    allConversation = await chatUseCase.getAllConversation();
    if (allConversation?.data != null) {
      // final newConversations = allConversation?.data
      //     ?.where((newPost) =>
      //         !conversations.any((cachedPost) => cachedPost.id == newPost.id))
      //     .toList();
      conversations.addAll(allConversation?.data as Iterable<UserConversation>);
      notifyListeners();
    }
  }

  Future<void> updateLastMessage({required dynamic messageData}) async {
    String lastMessage = messageData['latest_message'].toString();
    String senderId = messageData['sender_id'].toString();
    final userUtil = ref.watch(userUtilsProvider);
    String clientId = await userUtil.getUserId();
    String senderLastMessage = messageData['sender_latest_message'].toString();
    int conversationId = messageData['conversation_id'] ?? 0;
    int messageId = messageData['message_id'] ?? 0;

    final conversation =
        conversations.firstWhere((e) => e.id == conversationId);

    // if (messageData['updatedStatus'] != "read") {

    notifyListeners();
    // conversations

    if (clientId != senderId) {
      final newConversation = conversation.copyWith(
        latestMessage: lastMessage,
        updatedAt: DateTime.now().toIso8601String(),
      );

      conversations
          .removeWhere((conversation) => conversation.id == conversationId);
      conversations.insert(0, newConversation);

      // await markDeliveredMessage(
      //     senderId: senderId,
      //     messageId: messageId,
      //     conversationId: conversationId);
      // await Future.delayed(Duration(seconds: 3));
    } else {
      final newConversation = conversation.copyWith(
        latestMessage: senderLastMessage,
        updatedAt: DateTime.now().toIso8601String(),
      );
      // print(">>>>>>>new: ${jsonEncode(newConversation)}");
      conversations
          .removeWhere((conversation) => conversation.id == conversationId);
      conversations.insert(0, newConversation);
    }
    // notifyListeners();

    // .removeWhere((conversation) => conversation.id == conversationId);
  }

  Future<void> onInit() async {
    await initializeAbly();
    await listenAllConversation();
    print(">>>>>>>>>doneListen");
  }

  List<StreamSubscription<ably.Message>> messageSubscriptions = [];

  Future<StreamSubscription<ably.Message>?> listenAllConversation() async {
    for (UserConversation conversation in conversations) {
      final subscription = await chatUseCase.listenAllMessage(
        conversationId: conversation.id.toString(),
        handleChannelMessage: (message) async {
          print(">>>>>>>>>conversationData: ${message.data}");

          final messageData = jsonDecode(message.data.toString());
          await updateLastMessage(messageData: messageData);
        },
      );
      messageSubscriptions.add(subscription);
    }

    return messageSubscriptions.isNotEmpty ? messageSubscriptions.first : null;
  }

  Future<void> markDeliveredMessage({
    required String senderId,
    required dynamic messageId,
    required dynamic conversationId,
  }) async {
    // final userUtil = ref.watch(userUtilsProvider);
    // String clientId = await userUtil.getUserId();

    String data = jsonEncode({
      "topic": "statusMessage",
      "id": messageId,
      "updatedStatus": "delivered",
    });
    await chatUseCase
        .publishMessage(conversationId: conversationId.toString(), data: data)
        .catchError((e) {
      print(e);
    });
    chatUseCase.postMarkDeliveredMessage(MarkReadMessageRequest(
      conversationId: conversationId,
    ));
  }

  Future<void> markReadMessage({
    required dynamic senderId,
    required dynamic messageId,
    required dynamic conversationId,
  }) async {
    final userUtil = ref.watch(userUtilsProvider);
    String clientId = await userUtil.getUserId();

    if (clientId != senderId) {
      String data = jsonEncode(
          {"topic": "statusMessage", "id": messageId, "updatedStatus": "read"});
      await chatUseCase
          .publishMessage(conversationId: conversationId.toString(), data: data)
          .then((val) async {});
    }
    chatUseCase.postMarkReadMessage(MarkReadMessageRequest(
      conversationId: int.parse(conversationId),
    ));
  }

  Future<void> initializeAbly() async => await chatUseCase.initialize();

  Stream<Map<dynamic, dynamic>> listenUsersStatus(String userId) {
    return chatUseCase.listenUsersStatus().map((event) {
      final rawData = event.snapshot.value;
      if (rawData is Map) {
        final usersStatus =
            rawData.entries.where((entry) => entry.value is Map).map((entry) {
          final element = Map<dynamic, dynamic>.from(entry.value);
          element['userId'] = entry.key;
          return element;
        }).toList();
        Map<dynamic, dynamic> userStatus =
            usersStatus.firstWhere((user) => user['userId'] == userId);
        return userStatus;
      }
      return {};
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    for (var subscription in messageSubscriptions) {
      subscription.cancel(); // Huỷ tất cả subscription khi dispose
    }
    // connectSubscription?.cancel();
    super.dispose();
  }

  List<Data> friends = [];
  Future<void> getFriends() async {
    friends.clear();
    notifyListeners();
    final data = await chatUseCase.getFriendInChat();
    List<dynamic> followerJson = data['data'];
    await mapFriendsFromJson(followerJson);
    notifyListeners();
  }

  Future<void> mapFriendsFromJson(List<dynamic> followerJson) async {
    friends = followerJson
        .whereType<Map<String, dynamic>>()
        .map((item) => Data.fromJson(item))
        .toList();
  }

  StreamSubscription<ably.ConnectionStateChange>? connectSubscription;
  Future<StreamSubscription<ably.ConnectionStateChange>?> listenAblyConnected(
      {required Function(ably.ConnectionStateChange stateChange)
          handleChannelStateChange}) async {
    connectSubscription = await chatUseCase.listenAblyConnected(
        handleChannelStateChange: handleChannelStateChange);
    return connectSubscription;
  }
}

final conversationControllerProvider = ChangeNotifierProvider((ref) {
  final chatUseCase = ref.watch(chatUseCaseProvider);

  return ConversationController(chatUseCase, ref);
});
