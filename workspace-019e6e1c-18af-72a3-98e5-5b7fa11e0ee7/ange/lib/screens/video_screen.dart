import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../core/theme.dart';
import '../providers/media_provider.dart';
import '../models/media_item.dart';
import 'video_player_screen.dart';

class VideoScreen extends StatelessWidget {
  const VideoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<MediaProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('FILMS & VIDÉOS')),
      body: prov.isLoading
          ? const Center(child: CircularProgressIndicator(color: AppTheme.gold))
          : prov.videos.isEmpty
              ? _buildEmpty('Aucune vidéo trouvée.')
              : RefreshIndicator(
                  color: AppTheme.gold,
                  backgroundColor: AppTheme.cardBackground,
                  onRefresh: () => prov.refresh(),
                  child: GridView.builder(
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 120),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, childAspectRatio: 0.75, crossAxisSpacing: 12, mainAxisSpacing: 12,
                    ),
                    itemCount: prov.videos.length,
                    itemBuilder: (ctx, i) {
                      final vid = prov.videos[i];
                      return VideoCard(video: vid, onTap: () {
                        Navigator.push(ctx, MaterialPageRoute(builder: (_) => VideoPlayerScreen(item: vid)));
                      });
                    },
                  ),
                ),
    );
  }

  Widget _buildEmpty(String msg) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.videocam_off_rounded, size: 64, color: AppTheme.textSecondary),
          const SizedBox(height: 16),
          Text(msg, textAlign: TextAlign.center, style: const TextStyle(color: AppTheme.textSecondary)),
        ],
      ),
    );
  }
}

class VideoCard extends StatefulWidget {
  final MediaItem video;
  final VoidCallback onTap;
  const VideoCard({super.key, required this.video, required this.onTap});

  @override
  State<VideoCard> createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard> {
  Uint8List? thumb;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadThumb();
  }

  Future<void> _loadThumb() async {
    try {
      final t = await VideoThumbnail.thumbnailData(
        video: widget.video.path,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 300,
        maxHeight: 400,
        quality: 80,
      );
      if (mounted) setState(() { thumb = t; loading = false; });
    } catch (e) {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppTheme.cardBackground,
          boxShadow: [BoxShadow(color: AppTheme.fireRed.withOpacity(0.1), blurRadius: 8)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: loading
                    ? Shimmer.fromColors(
                        baseColor: Colors.grey.shade900,
                        highlightColor: Colors.grey.shade800,
                        child: Container(color: Colors.black),
                      )
                    : thumb != null
                        ? Image.memory(thumb!, fit: BoxFit.cover)
                        : Container(color: Colors.black, child: const Center(child: Icon(Icons.videocam, color: AppTheme.textSecondary))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.video.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
                  const SizedBox(height: 4),
                  Text(widget.video.displayDuration, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
