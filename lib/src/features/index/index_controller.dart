import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IndexController extends StateNotifier<bool> {
  IndexController() : super(true);
  bool isBottomNavigationBarVisible = true;

  void setBottomNavigationBarVisibility(bool visible) {
    state = visible;
  }

  void showBottomSheet(
      {required BuildContext context,
      required Widget Function(ScrollController) builder}) {
    setBottomNavigationBarVisibility(false);
    showModalBottomSheet(
        isScrollControlled: true,
        useRootNavigator: true,
        context: context,
        builder: (context) => DraggableScrollableSheet(
              expand: false,
              snap: false,
              initialChildSize: 0.7,
              maxChildSize: 0.95,
              minChildSize: 0.7,
              builder: (context, scrollController) => builder(scrollController),
            ));
  }
}

final indexControllerProvider =
    StateNotifierProvider<IndexController, bool>((ref) => IndexController());
