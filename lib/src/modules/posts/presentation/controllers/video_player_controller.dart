import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VideoPlayerController extends ChangeNotifier {
  BetterPlayerController? betterPlayerController;
  String? currentVideoUrl;

  void initializePlayer(String videoUrl) {
    if (betterPlayerController == null || currentVideoUrl != videoUrl) {
      disposePlayer();
      final playerConfiguration = const BetterPlayerConfiguration(
          aspectRatio: 4 / 5,
          autoPlay: false,
          looping: false,
          controlsConfiguration: BetterPlayerControlsConfiguration(
              showControlsOnInitialize: false, enableFullscreen: false));

      final betterPlayerDataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        videoUrl,
      );

      betterPlayerController = BetterPlayerController(
        playerConfiguration,
        betterPlayerDataSource: betterPlayerDataSource,
      );
      currentVideoUrl = videoUrl;
      notifyListeners();
    }
  }

  void disposePlayer() {
    betterPlayerController?.dispose();
    betterPlayerController = null;
    notifyListeners();
  }
}

// Tạo provider cho VideoPlayerNotifier
final videoPlayerProvider =
    ChangeNotifierProvider.family<VideoPlayerController, String>(
  (ref, videoUrl) {
    final controller = VideoPlayerController();
    ref.onDispose(() => controller
        .disposePlayer()); // Dispose controller when the provider is disposed
    controller.initializePlayer(videoUrl);
    return controller;
  },
);
