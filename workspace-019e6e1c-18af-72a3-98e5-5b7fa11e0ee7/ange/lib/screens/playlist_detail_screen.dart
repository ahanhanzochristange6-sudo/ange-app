import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../models/playlist_model.dart';
import '../providers/media_provider.dart';
import '../widgets/glass_card.dart';
import 'player_screen.dart';

class PlaylistDetailScreen extends StatelessWidget {
  final PlaylistModel playlist;
  const PlaylistDetailScreen({super.key, required this.playlist});

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<MediaProvider>();
    final updated = prov.playlists.firstWhere((p) => p.id == playlist.id, orElse: () => playlist);
    return Scaffold(
      appBar: AppBar(
        title: Text(updated.name.toUpperCase()),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever_rounded, color: Colors.redAccent),
            onPressed: () async {
              await prov.deletePlaylist(updated.id!);
              if (context.mounted) Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (updated.songs.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: NeonButton(
                onPressed: () {
                  prov.playMusic(updated.songs.first, queue: updated.songs, index: 0);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const PlayerScreen()));
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.play_arrow_rounded, color: Colors.white),
                    SizedBox(width: 8),
                    Text('LECTURE', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                  ],
                ),
              ),
            ),
          Expanded(
            child: updated.songs.isEmpty
                ? const Center(child: Text('Playlist vide', style: TextStyle(color: AppTheme.textSecondary)))
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
                    itemCount: updated.songs.length,
                    itemBuilder: (ctx, i) {
                      final song = updated.songs[i];
                      return GlassCard(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Container(
                            width: 44, height: 44,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(colors: [AppTheme.fireRed, AppTheme.gold]),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.music_note_rounded, color: Colors.white),
                          ),
                          title: Text(song.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w700)),
                          subtitle: Text(song.artist, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.play_circle_fill_rounded, color: AppTheme.gold),
                                onPressed: () {
                                  prov.playMusic(song, queue: updated.songs, index: i);
                                  Navigator.push(ctx, MaterialPageRoute(builder: (_) => const PlayerScreen()));
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline_rounded, color: Colors.redAccent),
                                onPressed: () => prov.removeFromPlaylist(updated.id!, song.id),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// Re-import néon button local s'il n'est pas accessible depuis ce fichier via import
class NeonButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final double width; final double height;
  const NeonButton({super.key, required this.onPressed, required this.child, this.width = double.infinity, this.height = 56});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width, height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: AppTheme.fireOrange.withOpacity(0.5), blurRadius: 12, offset: const Offset(0, 4)),
        ],
        gradient: const LinearGradient(colors: [AppTheme.fireRed, AppTheme.fireOrange]),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onPressed,
          splashColor: Colors.white24,
          child: Center(child: child),
        ),
      ),
    );
  }
}
