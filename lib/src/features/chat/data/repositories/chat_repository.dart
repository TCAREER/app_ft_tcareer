import 'dart:async';
import 'package:app_tcareer/src/features/chat/data/models/conversation.dart';
import 'package:app_tcareer/src/features/chat/data/models/send_message_request.dart';
import 'package:app_tcareer/src/services/ably/ably_service.dart';
import 'package:app_tcareer/src/services/apis/api_service_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ably_flutter/ably_flutter.dart' as ably;

class ChatRepository {
  final Ref ref;
  ChatRepository(this.ref);
  StreamSubscription<ably.Message> listenAllMessage(
      {required String channelName,
      required Function(ably.Message) handleChannelMessage}) {
    final ablyService = ref.watch(ablyServiceProvider);
    return ablyService.listenAllMessage(
        channelName: channelName, handleChannelMessage: handleChannelMessage);
  }

  Future<void> publishMessage(
      {required String channelName,
      required String name,
      required Object data}) async {
    final ablyService = ref.watch(ablyServiceProvider);
    return await ablyService.publishMessage(
        channelName: channelName, name: name, data: data);
  }

  Future<Conversation> getConversation(String userId) async {
    final api = ref.watch(apiServiceProvider);
    return await api.getConversation(userId: userId);
  }

  Future<void> sendMessage(SendMessageRequest body) async {
    final api = ref.watch(apiServiceProvider);
    return await api.postSendMessage(body: body);
  }
}

final chatRepositoryProvider =
    Provider<ChatRepository>((ref) => ChatRepository(ref));
