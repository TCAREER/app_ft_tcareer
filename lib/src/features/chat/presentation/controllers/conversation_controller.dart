import 'package:app_tcareer/src/features/chat/data/models/all_conversation.dart';
import 'package:app_tcareer/src/features/chat/data/models/user_conversation.dart';
import 'package:app_tcareer/src/features/chat/presentation/controllers/chat_controller.dart';
import 'package:app_tcareer/src/features/chat/usecases/chat_use_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConversationController extends ChangeNotifier {
  final ChatUseCase chatUseCase;

  ConversationController(this.chatUseCase);

  AllConversation? allConversation;
  List<UserConversation> conversations = [];
  Future<void> getAllConversation() async {
    allConversation = null;

    allConversation = await chatUseCase.getAllConversation();
    if (allConversation?.data != null) {
      final newConversations = allConversation?.data
          ?.where((newPost) =>
              !conversations.any((cachedPost) => cachedPost.id == newPost.id))
          .toList();
      conversations.clear();
      conversations.addAll(newConversations as Iterable<UserConversation>);
      notifyListeners();
    }
  }

  Future<void> onInit() async {
    if (allConversation?.data == null) {
      await getAllConversation();
    }
  }
}

final conversationControllerProvider =
    ChangeNotifierProvider<ConversationController>((ref) {
  final chatUseCase = ref.watch(chatUseCaseProvider);

  return ConversationController(chatUseCase);
});
