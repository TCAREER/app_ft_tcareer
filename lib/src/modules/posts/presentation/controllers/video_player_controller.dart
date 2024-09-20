import 'package:app_tcareer/src/configs/app_constants.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerControllerNotifier extends ChangeNotifier {
  VideoPlayerController? videoPlayerController;
  String? currentVideoUrl;
  FlickManager? flickManager;

  // Khởi tạo video player
  void initializePlayer(String videoUrl) async {
    if (videoPlayerController == null || currentVideoUrl != videoUrl) {
      disposePlayer();
      videoPlayerController =
          VideoPlayerController.network("$videoUrl&${AppConstants.driveApiKey}")
            ..setLooping(false);
      flickManager = FlickManager(
          videoPlayerController: videoPlayerController!,
          autoPlay: false,
          autoInitialize: true);
      // await videoPlayerController!.initialize(); // Chờ khởi tạo
      notifyListeners(); // Chỉ notify sau khi khởi tạo xong
      currentVideoUrl = videoUrl;
    }
  }

  void disposePlayer() {
    videoPlayerController?.dispose();
    flickManager?.dispose();
    videoPlayerController = null;
    notifyListeners();
  }
}

// Tạo provider cho VideoPlayerControllerNotifier
final videoPlayerProvider =
    ChangeNotifierProvider.family<VideoPlayerControllerNotifier, String>(
  (ref, videoUrl) {
    final controller = VideoPlayerControllerNotifier();
    ref.onDispose(() => controller
        .disposePlayer()); // Dispose controller when the provider is disposed
    controller.initializePlayer(videoUrl);
    return controller;
  },
);
