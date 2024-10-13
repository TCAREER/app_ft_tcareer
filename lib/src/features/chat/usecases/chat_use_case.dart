import 'dart:async';
import 'package:ably_flutter/ably_flutter.dart' as ably;
import 'package:app_tcareer/src/features/chat/data/models/conversation.dart';
import 'package:app_tcareer/src/features/chat/data/models/send_message_request.dart';
import 'package:app_tcareer/src/features/chat/data/repositories/chat_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatUseCase {
  final ChatRepository chatRepository;
  ChatUseCase(this.chatRepository);

  StreamSubscription<ably.Message> listenAllMessage(
          {required Function(ably.Message) handleChannelMessage,
          required String conversationId}) =>
      chatRepository.listenAllMessage(
          channelName: "conversation-$conversationId",
          handleChannelMessage: handleChannelMessage);
  Future<void> publishMessage(
      {required String name, required Object data}) async {
    return await chatRepository.publishMessage(
        channelName: "tcareer", name: name, data: data);
  }

  Future<Conversation> getConversation(String userId) async =>
      await chatRepository.getConversation(userId);

  Future<void> sendMessage(SendMessageRequest body) async =>
      await chatRepository.sendMessage(body);
}

final chatUseCaseProvider = Provider<ChatUseCase>((ref) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  return ChatUseCase(chatRepository);
});
