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
    final mediaController = ref.watch(mediaControllerProvider);
    return flickManager != null
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Stack(
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: FlickVideoPlayer(flickManager: flickManager!)),
                Positioned(
                  right: 15,
                  top: 5,
                  child: GestureDetector(
                    onTap: () {
                      // Gọi hàm để xóa ảnh tại index
                      mediaController.removeVideo();
                    },
                    child: Opacity(
                      opacity: 0.5,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        : const Center(child: CircularProgressIndicator());
  }
}
