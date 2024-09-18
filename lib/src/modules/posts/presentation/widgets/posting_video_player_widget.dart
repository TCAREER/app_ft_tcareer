import 'dart:io';
import 'package:app_tcareer/src/modules/posts/presentation/posts_provider.dart';
import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PostingVideoPlayerWidget extends ConsumerStatefulWidget {
  // Đường dẫn đến file video

  const PostingVideoPlayerWidget({Key? key}) : super(key: key);

  @override
  _PostingVideoPlayerWidgetState createState() =>
      _PostingVideoPlayerWidgetState();
}

class _PostingVideoPlayerWidgetState
    extends ConsumerState<PostingVideoPlayerWidget> {
  BetterPlayerController? _betterPlayerController;

  @override
  void initState() {
    super.initState();
    final controller = ref.read(mediaControllerProvider);

    final playerConfiguration = BetterPlayerConfiguration(
      aspectRatio:
          4 / 5, // Hoặc bạn có thể tính toán tỷ lệ khung hình từ video nếu cần
      autoPlay: false,
      looping: true,
      controlsConfiguration: BetterPlayerControlsConfiguration(
        showControlsOnInitialize: false,
      ),
    );

    final betterPlayerDataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.file,
      controller.videoPaths ?? "",
    );

    _betterPlayerController = BetterPlayerController(
      playerConfiguration,
      betterPlayerDataSource: betterPlayerDataSource,
    );
  }

  @override
  void dispose() {
    _betterPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.read(mediaControllerProvider);
    return _betterPlayerController != null
        ? BetterPlayer(controller: _betterPlayerController!)
        : const Center(child: CircularProgressIndicator());
  }
}
