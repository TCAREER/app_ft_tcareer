import 'package:app_tcareer/src/modules/posts/presentation/controllers/video_player_controller.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoPlayerWidget extends ConsumerWidget {
  final String videoUrl;

  const VideoPlayerWidget({Key? key, required this.videoUrl}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(videoPlayerProvider(videoUrl));

    final videoPlayerController = controller.videoPlayerController;

    return VisibilityDetector(
      key: Key(videoUrl),
      child: videoPlayerController != null && controller.flickManager != null
          ? FlickVideoPlayer(
              flickManager: controller.flickManager!,
            )
          : const Center(child: CircularProgressIndicator()),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.5) {
          videoPlayerController?.play();
        } else {
          videoPlayerController?.pause();
        }
      },
    );
  }
}
