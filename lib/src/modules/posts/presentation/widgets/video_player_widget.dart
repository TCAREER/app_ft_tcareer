import 'package:app_tcareer/src/modules/posts/presentation/controllers/video_player_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:better_player/better_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoPlayerWidget extends ConsumerStatefulWidget {
  final String videoUrl;

  const VideoPlayerWidget({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends ConsumerState<VideoPlayerWidget> {
  late VideoPlayerController videoPlayerController;

  @override
  void initState() {
    super.initState();
    // Initialize the video player controller
    videoPlayerController = ref.read(videoPlayerProvider(widget.videoUrl));
    videoPlayerController.initializePlayer(widget.videoUrl);
  }

  @override
  void didUpdateWidget(covariant VideoPlayerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoUrl != widget.videoUrl) {
      // Reinitialize the player if the URL changes
      videoPlayerController.disposePlayer();
      videoPlayerController.initializePlayer(widget.videoUrl);
    }
  }

  @override
  void dispose() {
    // Dispose the player when the widget is removed from the widget tree
    videoPlayerController.disposePlayer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final betterPlayerController = videoPlayerController.betterPlayerController;
    return VisibilityDetector(
      key: Key(widget.videoUrl),
      child: betterPlayerController != null
          ? BetterPlayer(controller: betterPlayerController)
          : const Center(child: CircularProgressIndicator()),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.5) {
          betterPlayerController?.play();
        } else {
          betterPlayerController?.pause();
        }
      },
    );
  }
}
