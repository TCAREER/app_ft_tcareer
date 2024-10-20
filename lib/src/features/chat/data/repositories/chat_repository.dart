import 'dart:async';
import 'dart:io';
import 'package:app_tcareer/src/features/chat/data/models/all_conversation.dart';
import 'package:app_tcareer/src/features/chat/data/models/conversation.dart';
import 'package:app_tcareer/src/features/chat/data/models/leave_chat_request.dart';
import 'package:app_tcareer/src/features/chat/data/models/mark_read_message_request.dart';
import 'package:app_tcareer/src/features/chat/data/models/send_message_request.dart';
import 'package:app_tcareer/src/services/ably/ably_service.dart';
import 'package:app_tcareer/src/services/apis/api_service_provider.dart';
import 'package:app_tcareer/src/services/drive/upload_file_service.dart';
import 'package:app_tcareer/src/services/firebase/firebase_storage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ably_flutter/ably_flutter.dart' as ably;

class ChatRepository {
  final Ref ref;
  ChatRepository(this.ref);

  Future<void> initialize() async {
    final ablyService = ref.watch(ablyServiceProvider);
    return ablyService.initialize();
  }

  StreamSubscription<ably.Message> listenAllMessage(
      {required String channelName,
      required Function(ably.Message) handleChannelMessage}) {
    final ablyService = ref.watch(ablyServiceProvider);
    return ablyService.listenAllMessage(
        channelName: channelName, handleChannelMessage: handleChannelMessage);
  }

  Future<void> publishMessage(
      {required String channelName, required Object data}) async {
    final ablyService = ref.watch(ablyServiceProvider);
    return await ablyService.publishMessage(
        channelName: channelName, data: data);
  }

  Future<Conversation> getConversation(String userId) async {
    final api = ref.watch(apiServiceProvider);
    return await api.getConversation(userId: userId);
  }

  Future<void> sendMessage(SendMessageRequest body) async {
    final api = ref.watch(apiServiceProvider);
    return await api.postSendMessage(body: body);
  }

  Future<void> enterPresence(
      {required String channelName, required String userId}) async {
    final ablyService = ref.watch(ablyServiceProvider);
    return await ablyService.enterPresence(
        channelName: channelName, userId: userId);
  }

  Future<void> leavePresence(
      {required String channelName, required String userId}) async {
    final ablyService = ref.watch(ablyServiceProvider);
    return await ablyService.leavePresence(
        channelName: channelName, userId: userId);
  }

  StreamSubscription<ably.PresenceMessage> listenPresence(
      {required String channelName,
      required Function(ably.PresenceMessage) handleChannelPresence}) {
    final ablyService = ref.watch(ablyServiceProvider);
    return ablyService.listenPresence(
        channelName: channelName, handleChannelPresence: handleChannelPresence);
  }

  Future<void> disconnect() async {
    final ablyService = ref.watch(ablyServiceProvider);
    return await ablyService.disconnect();
  }

  Future<void> dispose() async {
    final ablyService = ref.watch(ablyServiceProvider);
    return await ablyService.dispose();
  }

  Future<String> uploadImage(
      {required File file, required String folderPath}) async {
    final storage = ref.watch(firebaseStorageServiceProvider);
    return await storage.uploadFile(file, folderPath);
  }

  Future<String> uploadVideo(
      {required File file,
      required String folderName,
      required String topic}) async {
    final upload = ref.watch(uploadFileServiceProvider);
    return await upload.uploadFile(
        topic: topic, folderName: folderName, file: file);
  }

  Future<void> putLeavedChat(LeaveChatRequest body) async {
    final api = ref.watch(apiServiceProvider);
    return await api.putLeaveChat(body: body);
  }

  Future<void> postMarkReadMessage(MarkReadMessageRequest body) async {
    final api = ref.watch(apiServiceProvider);
    return await api.postMarkReadMessage(body: body);
  }

  Future<AllConversation> getAllConversation() async {
    final api = ref.watch(apiServiceProvider);
    return await api.getAllConversation();
  }
}

final chatRepositoryProvider =
    Provider<ChatRepository>((ref) => ChatRepository(ref));
