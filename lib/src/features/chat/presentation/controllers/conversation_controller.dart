import 'dart:async';
import 'dart:convert';
import 'package:ably_flutter/ably_flutter.dart' as ably;
import 'package:app_tcareer/src/features/chat/data/models/all_conversation.dart';
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

  Future<void> updateLastMessage(
      {required String senderId, required dynamic messageData}) async {
    String lastMessage = messageData['latest_message'].toString();

    String senderLastMessage = messageData['sender_latest_message'].toString();
    int conversationId = messageData['conversation_id'] ?? 0;

    final userUtil = ref.watch(userUtilsProvider);
    String clientId = await userUtil.getUserId();
    final conversation =
        conversations.firstWhere((e) => e.id == conversationId);

    // conversations
    if (clientId != senderId) {
      final newConversation = conversation.copyWith(
        latestMessage: lastMessage,
        updatedAt: DateTime.now().toIso8601String(),
      );

      conversations
          .removeWhere((conversation) => conversation.id == conversationId);
      conversations.insert(0, newConversation);
      notifyListeners();
    } else {
      final newConversation = conversation.copyWith(
        latestMessage: senderLastMessage,
        updatedAt: DateTime.now().toIso8601String(),
      );
      // print(">>>>>>>new: ${jsonEncode(newConversation)}");
      conversations
          .removeWhere((conversation) => conversation.id == conversationId);
      conversations.insert(0, newConversation);
      notifyListeners();
    }
    // notifyListeners();

    // .removeWhere((conversation) => conversation.id == conversationId);
  }

  Future<void> onInit() async {
    await initializeAbly();
    listenAllConversation();
  }

  List<StreamSubscription<ably.Message>> messageSubscriptions = [];

  StreamSubscription<ably.Message>? listenAllConversation() {
    for (UserConversation conversation in conversations) {
      final subscription = chatUseCase.listenAllMessage(
        conversationId: conversation.id.toString(),
        handleChannelMessage: (message) {
          final messageData = jsonDecode(message.data.toString());
          updateLastMessage(
              senderId: conversation.userId.toString(),
              messageData: messageData);
        },
      );
      messageSubscriptions.add(subscription);
    }

    return messageSubscriptions.isNotEmpty ? messageSubscriptions.first : null;
  }

  Future<void> initializeAbly() async => await chatUseCase.initialize();

  @override
  void dispose() {
    // TODO: implement dispose
    for (var subscription in messageSubscriptions) {
      subscription.cancel(); // Huỷ tất cả subscription khi dispose
    }
    super.dispose();
  }

  List<Data> friends = [];
  Future<void> getFriends() async {
    final userUseCase = ref.watch(userUseCaseProvider);
    final userUtil = ref.watch(userUtilsProvider);
    String clientId = await userUtil.getUserId();
    friends.clear();
    notifyListeners();
    final data = await userUseCase.getFriends(clientId);
    List<dynamic> followerJson = data['data'];
    await mapFollowerFromJson(followerJson);
    notifyListeners();
  }

  Future<void> mapFollowerFromJson(List<dynamic> followerJson) async {
    friends = followerJson
        .whereType<Map<String, dynamic>>()
        .map((item) => Data.fromJson(item))
        .toList();
  }
}

final conversationControllerProvider = ChangeNotifierProvider((ref) {
  final chatUseCase = ref.watch(chatUseCaseProvider);

  return ConversationController(chatUseCase, ref);
});
