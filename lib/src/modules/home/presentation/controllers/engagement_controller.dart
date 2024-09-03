import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EngagementState {
  Map<String, Reaction<String>?> selectedValue;
  Reaction<String>? selectedReaction;
  EngagementState({required this.selectedValue, this.selectedReaction});
}

Reaction<String> reactionDefault() {
  return const Reaction<String>(
    value: "love",
    icon: Text(
      textAlign: TextAlign.center,
      "♥️",
      style: const TextStyle(fontSize: 20),
    ),
    title: Text(
      "Yêu thích",
      style: TextStyle(
          fontSize: 13, color: Colors.red, fontWeight: FontWeight.w400),
    ),
  );
}

class EngagementController extends StateNotifier<EngagementState> {
  EngagementController() : super(EngagementState(selectedValue: {}));

  Future<void> onReactionChanged(
      {required String postId, required Reaction<String>? value}) async {
    // final reaction =
    //     Map<String, Reaction<String>>.from(state.selectedValue ?? {});
    // // if(reaction[postId]?.value==value?.value){
    // //   reaction.remove(postId);
    // //   state = EngagementState(selectedValue: reaction);
    // // }
    // reaction[postId] = value!;
    state = EngagementState(selectedValue: {}, selectedReaction: value);
    print(">>>>>>>>>>>val1: ${value?.title}");
  }

  Future<void> removeReaction() async {}
}

final engagementControllerProvider =
    StateNotifierProvider<EngagementController, EngagementState>((ref) {
  return EngagementController();
});
