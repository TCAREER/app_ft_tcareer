import 'dart:io';
import 'package:app_tcareer/src/configs/app_constants.dart';
import 'package:app_tcareer/src/modules/posts/presentation/posts_provider.dart';
import 'package:better_player/better_player.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

class PostingVideoPlayerWidget extends ConsumerStatefulWidget {
  // Đường dẫn đến file video

  const PostingVideoPlayerWidget({Key? key}) : super(key: key);

  @override
  _PostingVideoPlayerWidgetState createState() =>
      _PostingVideoPlayerWidgetState();
}

class _PostingVideoPlayerWidgetState
    extends ConsumerState<PostingVideoPlayerWidget> {
  FlickManager? flickManager;

  @override
  void initState() {
    super.initState();
    final controller = ref.read(mediaControllerProvider);
    final postingController = ref.read(postingControllerProvider);

    flickManager = FlickManager(
        videoPlayerController: kIsWeb
            ? VideoPlayerController.network(
                "${postingController.videoUrlWeb}&${AppConstants.driveApiKey}")
            : VideoPlayerController.file(File(controller.videoPaths ?? "")),
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
        ? FlickVideoPlayer(flickManager: flickManager!)
        : const Center(child: CircularProgressIndicator());
  }
}
