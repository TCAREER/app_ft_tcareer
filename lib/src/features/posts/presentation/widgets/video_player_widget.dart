import 'package:app_tcareer/src/widgets/cached_image_widget.dart';
import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:app_tcareer/src/configs/app_constants.dart';

class VideoPlayerWidget extends ConsumerStatefulWidget {
  final String videoUrl;

  const VideoPlayerWidget({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends ConsumerState<VideoPlayerWidget> {
  late BetterPlayerController _betterPlayerController;
  bool _isVideoInitialized = false;
  double _aspectRatio = 16 / 9; // Tỉ lệ mặc định

  @override
  void initState() {
    super.initState();
    initVideo();
  }

  Future<void> initVideo() async {
    // Khởi tạo cấu hình BetterPlayer với tỉ lệ khung hình mặc định
    BetterPlayerConfiguration betterPlayerConfiguration =
        BetterPlayerConfiguration(
      aspectRatio: _aspectRatio,
      autoPlay: false,
      looping: false,
      autoDispose: true,
      useRootNavigator: true,
      controlsConfiguration: const BetterPlayerControlsConfiguration(
          enableOverflowMenu: false,
          enablePlayPause: true,
          enableMute: true,
          enableFullscreen: false,
          showControlsOnInitialize: false,
          enablePip: false,
          enablePlaybackSpeed: false,
          enableQualities: false,
          enableSkips: false),
    );

    BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      "${widget.videoUrl}&${AppConstants.driveApiKey}",
    );

    _betterPlayerController = BetterPlayerController(
      betterPlayerConfiguration,
      betterPlayerDataSource: betterPlayerDataSource,
    );

    // Lắng nghe sự kiện khởi tạo video
    _betterPlayerController.addEventsListener((event) {
      if (event.betterPlayerEventType == BetterPlayerEventType.initialized) {
        setState(() {
          // Cập nhật tỷ lệ thực tế của video
          final aspectRatio =
              _betterPlayerController.videoPlayerController?.value.aspectRatio;
          if (aspectRatio != null) {
            // Nếu có tỉ lệ khung hình thực tế, cập nhật tỉ lệ
            _aspectRatio = aspectRatio;
            // Cập nhật cấu hình của BetterPlayerController
            _betterPlayerController = BetterPlayerController(
              BetterPlayerConfiguration(
                aspectRatio: _aspectRatio,
                autoDispose: true,
                useRootNavigator: true, // Cập nhật tỉ lệ khung hình ở đây
                autoPlay: false,
                looping: false,
                controlsConfiguration: const BetterPlayerControlsConfiguration(
                    enableOverflowMenu: false,
                    showControlsOnInitialize: false,
                    enablePlayPause: true,
                    enableMute: true,
                    enableFullscreen: false,
                    enablePip: false,
                    enablePlaybackSpeed: false,
                    enableQualities: false,
                    enableSkips: false),
              ),
              betterPlayerDataSource: betterPlayerDataSource,
            );
          }
          _isVideoInitialized = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _betterPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(widget.videoUrl),
      onVisibilityChanged: (info) {
        if (_isVideoInitialized) {
          if (info.visibleFraction > 0.8) {
            _betterPlayerController.play();
          } else {
            _betterPlayerController.pause();
          }
        }
      },
      child: _isVideoInitialized
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: BetterPlayer(controller: _betterPlayerController),
              ),
            )
          : imagePlaceholder(),
    );
  }
}
