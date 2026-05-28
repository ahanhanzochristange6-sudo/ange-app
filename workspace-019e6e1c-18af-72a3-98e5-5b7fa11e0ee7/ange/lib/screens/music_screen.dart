import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import '../core/theme.dart';
import '../providers/media_provider.dart';
import 'player_screen.dart';

class MusicScreen extends StatelessWidget {
  const MusicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<MediaProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('MUSIQUE')),
      body: prov.isLoading
          ? const Center(child: CircularProgressIndicator(color: AppTheme.gold))
          : prov.music.isEmpty
              ? _buildEmpty('Aucune musique trouvée. Vérifiez les permissions.')
              : RefreshIndicator(
                  color: AppTheme.gold,
                  backgroundColor: AppTheme.cardBackground,
                  onRefresh: () => prov.refresh(),
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
                    itemCount: prov.music.length,
                    itemBuilder: (ctx, i) {
                      final song = prov.music[i];
                      final isFav = prov.isFav(song.id);
                      return FadeInUp(
                        delay: Duration(milliseconds: (i % 15) * 40),
                        child: Card(
                          margin: const EdgeInsets.only(bottom: 10),
                          color: AppTheme.cardBackground,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 4,
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            leading: Container(
                              width: 48, height: 48,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(colors: [AppTheme.fireRed, AppTheme.gold]),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.music_note_rounded, color: Colors.white),
                            ),
                            title: Text(song.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w700)),
                            subtitle: Text('${song.artist} • ${song.displayDuration}', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded, color: isFav ? AppTheme.fireRed : Colors.grey),
                                  onPressed: () => prov.toggleFavorite(song),
                                ),
                                PopupMenuButton<String>(
                                  icon: const Icon(Icons.more_vert_rounded, color: AppTheme.textSecondary),
                                  color: AppTheme.cardBackground,
                                  onSelected: (val) {
                                    if (val == 'playlist') _showAddToPlaylist(ctx, song);
                                  },
                                  itemBuilder: (_) => [
                                    const PopupMenuItem(value: 'playlist', child: Text('Ajouter à une playlist', style: TextStyle(color: AppTheme.textPrimary))),
                                  ],
                                ),
                                Container(
                                  decoration: BoxDecoration(color: AppTheme.gold.withOpacity(0.15), shape: BoxShape.circle),
                                  child: IconButton(
                                    icon: const Icon(Icons.play_arrow_rounded, color: AppTheme.gold),
                                    onPressed: () {
                                      prov.playMusic(song, queue: prov.music, index: i);
                                      Navigator.push(ctx, MaterialPageRoute(builder: (_) => const PlayerScreen()));
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }

  void _showAddToPlaylist(BuildContext context, dynamic song) {
    final prov = context.read<MediaProvider>();
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.cardBackground,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('AJOUTER À', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 2)),
                const SizedBox(height: 12),
                if (prov.playlists.isEmpty)
                  const Text('Aucune playlist. Créez-en une dans l\'onglet Playlists.', style: TextStyle(color: AppTheme.textSecondary))
                else
                  ...prov.playlists.map((pl) => ListTile(
                    leading: const Icon(Icons.playlist_play_rounded, color: AppTheme.gold),
                    title: Text(pl.name, style: const TextStyle(color: AppTheme.textPrimary)),
                    onTap: () {
                      prov.addToPlaylist(pl.id!, song);
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
                        content: Text('Ajouté à ${pl.name}'),
                        backgroundColor: AppTheme.fireRed,
                      ));
                    },
                  )),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmpty(String msg) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.music_off_rounded, size: 64, color: AppTheme.textSecondary),
          const SizedBox(height: 16),
          Text(msg, textAlign: TextAlign.center, style: const TextStyle(color: AppTheme.textSecondary)),
        ],
      ),
    );
  }
}
