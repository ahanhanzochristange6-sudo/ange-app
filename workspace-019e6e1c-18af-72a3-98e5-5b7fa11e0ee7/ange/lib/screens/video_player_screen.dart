import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../core/theme.dart';
import '../models/media_item.dart';

class VideoPlayerScreen extends StatefulWidget {
  final MediaItem item;
  const VideoPlayerScreen({super.key, required this.item});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  bool _showControls = true;
  bool _isFullScreen = false;
  double _vol = 1.0;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.item.path))
      ..initialize().then((_) {
        _controller.play();
        _controller.setVolume(_vol);
        setState(() {});
      });
    _controller.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleControls() => setState(() => _showControls = !_showControls);

  void _seek(bool forward) {
    final pos = _controller.value.position;
    final dur = _controller.value.duration;
    final newPos = forward ? pos + const Duration(seconds: 10) : pos - const Duration(seconds: 10);
    _controller.seekTo(newPos.clamp(Duration.zero, dur));
  }

  @override
  Widget build(BuildContext context) {
    final value = _controller.value;
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: _toggleControls,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (value.isInitialized)
              Center(child: AspectRatio(aspectRatio: value.aspectRatio, child: VideoPlayer(_controller)))
            else
              const Center(child: CircularProgressIndicator(color: AppTheme.gold)),
            AnimatedOpacity(
              opacity: _showControls ? 1 : 0,
              duration: const Duration(milliseconds: 300),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter, end: Alignment.bottomCenter,
                    colors: [Colors.black87, Colors.transparent, Colors.transparent, Colors.black87],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          IconButton(icon: const Icon(Icons.arrow_back_rounded, color: Colors.white), onPressed: () => Navigator.pop(context)),
                          const Spacer(),
                          IconButton(
                            icon: Icon(_isFullScreen ? Icons.fullscreen_exit_rounded : Icons.fullscreen_rounded, color: Colors.white),
                            onPressed: () {
                              setState(() => _isFullScreen = !_isFullScreen);
                            },
                          ),
                        ],
                      ),
                      const Spacer(),
                      if (value.isInitialized) ...[
                        Slider(
                          value: value.position.inSeconds.toDouble().clamp(0, value.duration.inSeconds.toDouble()),
                          max: value.duration.inSeconds.toDouble(),
                          onChanged: (v) => _controller.seekTo(Duration(seconds: v.toInt())),
                          activeColor: AppTheme.fireOrange,
                          inactiveColor: Colors.white24,
                          thumbColor: AppTheme.gold,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(_fmt(value.position), style: const TextStyle(color: Colors.white70, fontSize: 12)),
                              Text(_fmt(value.duration), style: const TextStyle(color: Colors.white70, fontSize: 12)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(icon: const Icon(Icons.replay_10_rounded, color: Colors.white, size: 36), onPressed: () => _seek(false)),
                            const SizedBox(width: 20),
                            Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(colors: [AppTheme.fireRed, AppTheme.fireOrange]),
                              ),
                              child: IconButton(
                                iconSize: 42, color: Colors.white,
                                icon: Icon(value.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded),
                                onPressed: () => value.isPlaying ? _controller.pause() : _controller.play(),
                              ),
                            ),
                            const SizedBox(width: 20),
                            IconButton(icon: const Icon(Icons.forward_10_rounded, color: Colors.white, size: 36), onPressed: () => _seek(true)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const SizedBox(width: 16),
                            const Icon(Icons.volume_mute_rounded, color: Colors.white70, size: 20),
                            Expanded(
                              child: Slider(
                                value: _vol,
                                max: 1.0,
                                divisions: 20,
                                onChanged: (v) {
                                  setState(() => _vol = v);
                                  _controller.setVolume(v);
                                },
                                activeColor: AppTheme.gold,
                                inactiveColor: Colors.white24,
                                thumbColor: AppTheme.gold,
                              ),
                            ),
                            const Icon(Icons.volume_up_rounded, color: Colors.white70, size: 20),
                            const SizedBox(width: 16),
                          ],
                        ),
                        const SizedBox(height: 12),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _fmt(Duration d) {
    final m = d.inMinutes.toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}
