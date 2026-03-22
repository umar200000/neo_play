import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:neo_play/config/theme/colors/all_colors.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class VideoPlayerPage extends StatefulWidget {
  const VideoPlayerPage({super.key});

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late VideoPlayerController _controller;
  bool _showControls = true;
  bool _isFullScreen = false;
  bool _isMuted = false;
  bool _isLocked = false;
  Timer? _hideTimer;

  double _playbackSpeed = 1.0;
  String _currentQuality = "720p";

  final List<double> _speeds = [0.5, 0.75, 1.0, 1.25, 1.5, 2.0];
  final List<String> _qualities = ["1080p", "720p", "480p", "360p"];

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable(); // Screen always on
    _initializePlayer();
    _startHideTimer();
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _showControls = false;
        });
      }
    });
  }

  Future<void> _initializePlayer() async {
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(
        'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
      ),
    );

    try {
      await _controller.initialize();
      await _controller.setPlaybackSpeed(_playbackSpeed);

      _controller.addListener(_videoListener);

      if (mounted) {
        setState(() {});
        _controller.play();
      }
    } catch (e) {
      debugPrint("Video Player Error: $e");
    }
  }

  void _videoListener() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _changeQuality(String quality) async {
    if (_currentQuality == quality) return;

    final Duration currentPosition = _controller.value.position;
    final bool wasPlaying = _controller.value.isPlaying;

    _controller.removeListener(_videoListener);
    await _controller.dispose();

    setState(() {
      _currentQuality = quality;
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(
          'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
        ),
      );
    });

    try {
      await _controller.initialize();
      await _controller.seekTo(currentPosition);
      await _controller.setPlaybackSpeed(_playbackSpeed);

      _controller.addListener(_videoListener);

      if (wasPlaying) {
        _controller.play();
      }
      setState(() {});
    } catch (e) {
      debugPrint("Quality Change Error: $e");
    }
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    WakelockPlus.disable();
    _controller.removeListener(_videoListener);
    _controller.dispose();
    _resetOrientation();
    super.dispose();
  }

  void _toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
      if (_isFullScreen) {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
      } else {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        _resetOrientation();
      }
    });
    _startHideTimer();
  }

  void _resetOrientation() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  void _showSettingsModal() {
    _hideTimer?.cancel();
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          color: AllColors.cardColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSettingsOption(
              icon: Icons.speed_rounded,
              title: "Video tezligi",
              trailing: "${_playbackSpeed}x",
              onTap: () {
                Navigator.pop(context);
                _showSpeedSelector();
              },
            ),
            Gap(12.h),
            _buildSettingsOption(
              icon: Icons.hd_rounded,
              title: "Video sifati",
              trailing: _currentQuality,
              onTap: () {
                Navigator.pop(context);
                _showQualitySelector();
              },
            ),
            Gap(20.h),
          ],
        ),
      ),
    ).then((_) => _startHideTimer());
  }

  void _showSpeedSelector() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          color: AllColors.cardColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Video tezligini tanlang",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Gap(16.h),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _speeds.length,
                itemBuilder: (context, index) {
                  final speed = _speeds[index];
                  return ListTile(
                    title: Text(
                      "${speed}x",
                      style: const TextStyle(color: Colors.white),
                    ),
                    trailing: _playbackSpeed == speed
                        ? const Icon(Icons.check, color: AllColors.primaryColor)
                        : null,
                    onTap: () {
                      setState(() {
                        _playbackSpeed = speed;
                        _controller.setPlaybackSpeed(speed);
                      });
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ).then((_) => _startHideTimer());
  }

  void _showQualitySelector() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          color: AllColors.cardColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Video sifatini tanlang",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Gap(16.h),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _qualities.length,
                itemBuilder: (context, index) {
                  final quality = _qualities[index];
                  return ListTile(
                    title: Text(
                      quality,
                      style: const TextStyle(color: Colors.white),
                    ),
                    trailing: _currentQuality == quality
                        ? const Icon(Icons.check, color: AllColors.primaryColor)
                        : null,
                    onTap: () {
                      Navigator.pop(context);
                      _changeQuality(quality);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ).then((_) => _startHideTimer());
  }

  Widget _buildSettingsOption({
    required IconData icon,
    required String title,
    required String trailing,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(trailing, style: const TextStyle(color: AllColors.primaryColor)),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        final bool isLandscape = orientation == Orientation.landscape;

        return Scaffold(
          backgroundColor: Colors.black,
          body: WillPopScope(
            onWillPop: () async {
              // Har doim orqaga qaytish (sahifadan chiqish)
              return true;
            },
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                setState(() {
                  _showControls = !_showControls;
                });
                if (_showControls) {
                  _startHideTimer();
                } else {
                  _hideTimer?.cancel();
                }
              },
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Center(
                      child: _controller.value.isInitialized
                          ? AspectRatio(
                              aspectRatio: _controller.value.aspectRatio,
                              child: VideoPlayer(_controller),
                            )
                          : const CircularProgressIndicator(
                              color: AllColors.primaryColor,
                            ),
                    ),
                  ),
                  if (_controller.value.isInitialized &&
                      (_controller.value.isBuffering ||
                          !_controller.value.isInitialized))
                    const Center(
                      child: CircularProgressIndicator(
                        color: AllColors.primaryColor,
                      ),
                    ),
                  Positioned.fill(
                    child: AnimatedOpacity(
                      opacity: _showControls ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 300),
                      child: IgnorePointer(
                        ignoring: !_showControls,
                        child: Stack(
                          children: [
                            _buildTopBar(isLandscape),
                            if (!_isLocked) ...[
                              _buildCenterControls(isLandscape),
                              _buildBottomBar(isLandscape),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTopBar(bool isLandscape) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.fromLTRB(
          16.w,
          isLandscape ? 10.h : 40.h,
          16.w,
          10.h,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black.withOpacity(0.7), Colors.transparent],
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (!_isLocked)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Koperatsiya: Maxfiy hamkorlik",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isLandscape ? 12.sp : 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )
            else
              const Spacer(),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isLocked = !_isLocked;
                    });
                    if (!_isLocked) {
                      _showControls = true;
                      _startHideTimer();
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(isLandscape ? 4.r : 8.r),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _isLocked ? Icons.lock_rounded : Icons.lock_open_rounded,
                      color: _isLocked ? AllColors.primaryColor : Colors.white,
                      size: isLandscape ? 10.sp : 24.sp,
                    ),
                  ),
                ),
                if (!_isLocked) ...[
                  Gap(isLandscape ? 6.w : 8.w),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: isLandscape ? 12.sp : 28.sp,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterControls(bool isLandscape) {
    final bool isBuffering = _controller.value.isBuffering;

    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(
              Icons.replay_10_rounded,
              color: Colors.white,
              size: isLandscape ? 24.sp : 40.sp,
            ),
            onPressed: () {
              _controller.seekTo(
                _controller.value.position - const Duration(seconds: 10),
              );
              _startHideTimer();
            },
          ),
          Gap(isLandscape ? 24.w : 40.w),
          isBuffering
              ? SizedBox(
                  width: isLandscape ? 40.r : 72.r,
                  height: isLandscape ? 40.r : 72.r,
                  child: const CircularProgressIndicator(
                    color: AllColors.primaryColor,
                  ),
                )
              : GestureDetector(
                  onTap: () {
                    setState(() {
                      _controller.value.isPlaying
                          ? _controller.pause()
                          : _controller.play();
                    });
                    _startHideTimer();
                  },
                  child: Container(
                    padding: EdgeInsets.all(isLandscape ? 8.r : 16.r),
                    decoration: const BoxDecoration(
                      color: AllColors.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _controller.value.isPlaying
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: isLandscape ? 24.sp : 40.sp,
                    ),
                  ),
                ),
          Gap(isLandscape ? 24.w : 40.w),
          IconButton(
            icon: Icon(
              Icons.forward_10_rounded,
              color: Colors.white,
              size: isLandscape ? 24.sp : 40.sp,
            ),
            onPressed: () {
              _controller.seekTo(
                _controller.value.position + const Duration(seconds: 10),
              );
              _startHideTimer();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(bool isLandscape) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.fromLTRB(
          16.w,
          10.h,
          16.w,
          isLandscape ? 10.h : 40.h,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Colors.black.withOpacity(0.7), Colors.transparent],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${_formatDuration(_controller.value.position)} / ${_formatDuration(_controller.value.duration)}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isLandscape ? 9.sp : 12.sp,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        _isMuted
                            ? Icons.volume_off_rounded
                            : Icons.volume_up_rounded,
                        color: Colors.white,
                        size: isLandscape ? 14.sp : 20.sp,
                      ),
                      onPressed: () {
                        setState(() {
                          _isMuted = !_isMuted;
                          _controller.setVolume(_isMuted ? 0.0 : 1.0);
                        });
                        _startHideTimer();
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.settings_rounded,
                        color: Colors.white,
                        size: isLandscape ? 14.sp : 20.sp,
                      ),
                      onPressed: _showSettingsModal,
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.screen_rotation_rounded,
                        color: Colors.white,
                        size: isLandscape ? 14.sp : 20.sp,
                      ),
                      onPressed: _toggleFullScreen,
                    ),
                  ],
                ),
              ],
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onHorizontalDragStart: (_) => _hideTimer?.cancel(),
              onHorizontalDragEnd: (_) => _startHideTimer(),
              onTapDown: (_) => _hideTimer?.cancel(),
              onTapUp: (_) => _startHideTimer(),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 12.h,
                ), // Touch area increased
                child: VideoProgressIndicator(
                  _controller,
                  allowScrubbing: true,
                  padding: EdgeInsets.symmetric(
                    vertical: 4.h,
                  ), // Visual thickness
                  colors: VideoProgressColors(
                    playedColor: AllColors.primaryColor,
                    bufferedColor: Colors.white.withOpacity(0.2),
                    backgroundColor: Colors.white.withOpacity(0.1),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
