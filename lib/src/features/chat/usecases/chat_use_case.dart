import 'dart:async';
import 'package:ably_flutter/ably_flutter.dart' as ably;
import 'package:app_tcareer/src/features/chat/data/models/conversation.dart';
import 'package:app_tcareer/src/features/chat/data/models/send_message_request.dart';
import 'package:app_tcareer/src/features/chat/data/repositories/chat_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatUseCase {
  final ChatRepository chatRepository;
  ChatUseCase(this.chatRepository);

  Future<void> initialize() async => await chatRepository.initialize();

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

  Future<void> enterPresence(
          {required String conversationId, required String userId}) async =>
      await chatRepository.enterPresence(
          channelName: "conversation-$conversationId", userId: userId);

  Future<void> leavePresence(
          {required String conversationId, required String userId}) async =>
      await chatRepository.leavePresence(
          channelName: "conversation-$conversationId", userId: userId);

  StreamSubscription<ably.PresenceMessage> listenPresence(
          {required String conversationId,
          required Function(ably.PresenceMessage) handleChannelPresence}) =>
      chatRepository.listenPresence(
          channelName: "conversation-$conversationId",
          handleChannelPresence: handleChannelPresence);

  Future<void> disconnect() async => await chatRepository.disconnect();

  Future<void> dispose() async => await chatRepository.dispose();
}

final chatUseCaseProvider = Provider<ChatUseCase>((ref) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  return ChatUseCase(chatRepository);
});
