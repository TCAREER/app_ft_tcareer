import 'dart:convert';

import 'package:app_tcareer/src/features/chat/data/models/all_conversation.dart';
import 'package:app_tcareer/src/features/chat/data/models/user_conversation.dart';
import 'package:app_tcareer/src/features/chat/presentation/controllers/chat_controller.dart';
import 'package:app_tcareer/src/features/chat/usecases/chat_use_case.dart';
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
    print(">>>>>>>>>>>>conversation: ${jsonEncode(conversation)}");
    // conversations
    if (clientId != senderId) {
      final newConversation = conversation.copyWith(
        latestMessage: lastMessage,
        updatedAt: DateTime.now().toIso8601String(),
      );
      print(">>>>>>>new: ${jsonEncode(newConversation)}");
      conversations
          .removeWhere((conversation) => conversation.id == conversationId);
      conversations.insert(0, newConversation);
      notifyListeners();
    } else {
      final newConversation = conversation.copyWith(
        latestMessage: senderLastMessage,
        updatedAt: DateTime.now().toIso8601String(),
      );
      print(">>>>>>>new: ${jsonEncode(newConversation)}");
      conversations
          .removeWhere((conversation) => conversation.id == conversationId);
      conversations.insert(0, newConversation);
      notifyListeners();
    }
    // notifyListeners();
    print(">>>>>>>>>>>>>conversations: ${jsonEncode(conversations.first)}");
    //     .removeWhere((conversation) => conversation.id == conversationId);
  }

  Future<void> onInit() async {
    if (allConversation?.data == null) {
      await getAllConversation();
    }
  }
}

final conversationControllerProvider = ChangeNotifierProvider((ref) {
  final chatUseCase = ref.watch(chatUseCaseProvider);

  return ConversationController(chatUseCase, ref);
});
