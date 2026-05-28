import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../providers/media_provider.dart';
import '../widgets/glass_card.dart';
import 'player_screen.dart';
import 'video_player_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<MediaProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('FAVORIS')),
      body: prov.favorites.isEmpty
          ? _empty()
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
              itemCount: prov.favorites.length,
              itemBuilder: (ctx, i) {
                final item = prov.favorites[i];
                return GlassCard(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: ListTile(
                    leading: Container(
                      width: 44, height: 44,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: item.type == 'music' ? [AppTheme.fireRed, AppTheme.gold] : [AppTheme.fireOrange, Colors.deepOrange]),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(item.type == 'music' ? Icons.music_note_rounded : Icons.videocam_rounded, color: Colors.white),
                    ),
                    title: Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w700)),
                    subtitle: Text(item.artist.isNotEmpty ? item.artist : item.type.toUpperCase(), style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.play_circle_fill_rounded, color: AppTheme.gold),
                          onPressed: () {
                            if (item.type == 'music') {
                              prov.playMusic(item);
                              Navigator.push(ctx, MaterialPageRoute(builder: (_) => const PlayerScreen()));
                            } else {
                              Navigator.push(ctx, MaterialPageRoute(builder: (_) => VideoPlayerScreen(item: item)));
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.favorite_rounded, color: AppTheme.fireRed),
                          onPressed: () => prov.toggleFavorite(item),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _empty() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border_rounded, size: 64, color: AppTheme.textSecondary),
          SizedBox(height: 16),
          Text('Aucun favori', style: TextStyle(color: AppTheme.textSecondary)),
        ],
      ),
    );
  }
}
