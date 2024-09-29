import 'package:app_tcareer/src/widgets/cached_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:app_tcareer/src/configs/app_constants.dart';

class VideoPlayerWidget extends ConsumerStatefulWidget {
  final String videoUrl;

  const VideoPlayerWidget({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends ConsumerState<VideoPlayerWidget> {
  late VideoPlayerController _videoPlayerController;
  bool showControls = false;
  double controlOpacity = 0.0;
  bool _isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
    initVideo();
  }

  Future<void> initVideo() async {
    _videoPlayerController = VideoPlayerController.network(
      "${widget.videoUrl}&${AppConstants.driveApiKey}",
    );
    try {
      await _videoPlayerController.initialize();
      if (mounted) {
        setState(() {
          _isVideoInitialized = true;
        });
      }
    } catch (e) {
      // Xử lý lỗi khi không thể khởi tạo video
      debugPrint("Lỗi khởi tạo video: $e");
    }

    // Lắng nghe sự thay đổi của video để cập nhật trạng thái nếu cần
    _videoPlayerController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  void toggleControl() {
    setState(() {
      controlOpacity = 1.0; // Hiển thị ngay lập tức
    });

    // Tạo một delay 3 giây rồi ẩn nút điều khiển
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && controlOpacity == 1.0) {
        setState(() {
          controlOpacity = 0.0; // Ẩn sau 3 giây
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(widget.videoUrl),
      child: _isVideoInitialized
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: GestureDetector(
                  onTap: toggleControl,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      AspectRatio(
                        aspectRatio: _videoPlayerController.value.aspectRatio,
                        child: VideoPlayer(_videoPlayerController),
                      ),
                      // Nút Play/Pause
                      AnimatedOpacity(
                        opacity: controlOpacity,
                        duration: const Duration(milliseconds: 300),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              if (_videoPlayerController.value.isPlaying) {
                                _videoPlayerController.pause();
                              } else {
                                _videoPlayerController.play();
                              }
                            });
                          },
                          child: Icon(
                            _videoPlayerController.value.isPlaying
                                ? Icons.pause
                                : Icons.play_arrow,
                            size: 64,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      // Nút Bật/Tắt Âm thanh
                      Positioned(
                        right: 10,
                        bottom: 16,
                        child: AnimatedOpacity(
                          opacity: controlOpacity,
                          duration: const Duration(milliseconds: 300),
                          child: IconButton(
                            icon: Icon(
                              _videoPlayerController.value.volume > 0
                                  ? Icons.volume_up
                                  : Icons.volume_off,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                _videoPlayerController.setVolume(
                                  _videoPlayerController.value.volume > 0
                                      ? 0
                                      : 1,
                                );
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : imagePlaceholder(),
      onVisibilityChanged: (info) {
        if (_isVideoInitialized) {
          if (info.visibleFraction > 0.8) {
            // _videoPlayerController.play();
          } else {
            _videoPlayerController.pause();
          }
        }
      },
    );
  }
}
