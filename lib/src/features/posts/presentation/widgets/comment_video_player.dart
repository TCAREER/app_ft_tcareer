import 'dart:io';
import 'package:app_tcareer/src/configs/app_constants.dart';
import 'package:app_tcareer/src/features/posts/presentation/posts_provider.dart';
import 'package:better_player/better_player.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

class CommentVideoPlayerWidget extends ConsumerStatefulWidget {
  // Đường dẫn đến file video
  final String videoUrl;
  const CommentVideoPlayerWidget(this.videoUrl, {Key? key}) : super(key: key);

  @override
  _CommentVideoPlayerWidgetState createState() =>
      _CommentVideoPlayerWidgetState();
}

class _CommentVideoPlayerWidgetState
    extends ConsumerState<CommentVideoPlayerWidget> {
  FlickManager? flickManager;

  @override
  void initState() {
    super.initState();

    flickManager = FlickManager(
        videoPlayerController: VideoPlayerController.network(
            "${widget.videoUrl}&${AppConstants.driveApiKey}"),
        autoPlay: false,
        autoInitialize: true);
  }

  @override
  void dispose() {
    flickManager?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return flickManager != null
        ? SizedBox(
            height: 200,
            width: 200,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: FlickVideoPlayer(
                  flickManager: flickManager!,
                )),
          )
        : const Center(child: CircularProgressIndicator());
  }
}
