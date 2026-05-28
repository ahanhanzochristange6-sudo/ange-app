import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import '../core/theme.dart';
import '../providers/media_provider.dart';
import '../widgets/glass_card.dart';
import '../widgets/neon_button.dart';
import 'playlist_detail_screen.dart';

class PlaylistsScreen extends StatelessWidget {
  const PlaylistsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<MediaProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('PLAYLISTS')),
      body: prov.playlists.isEmpty
          ? _buildEmpty(context)
          : GridView.builder(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, childAspectRatio: 0.9, crossAxisSpacing: 12, mainAxisSpacing: 12,
              ),
              itemCount: prov.playlists.length,
              itemBuilder: (ctx, i) {
                final pl = prov.playlists[i];
                return FadeInUp(
                  delay: Duration(milliseconds: i * 80),
                  child: GestureDetector(
                    onTap: () => Navigator.push(ctx, MaterialPageRoute(builder: (_) => PlaylistDetailScreen(playlist: pl))),
                    child: GlassCard(
                      padding: EdgeInsets.zero,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                                gradient: LinearGradient(
                                  colors: pl.coverPath != null ? [AppTheme.fireRed, AppTheme.gold] : [AppTheme.cardBackground, AppTheme.surfaceRed],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                image: pl.coverPath != null
                                    ? DecorationImage(image: FileImage(File(pl.coverPath!)), fit: BoxFit.cover)
                                    : null,
                              ),
                              child: pl.coverPath == null
                                  ? const Center(child: Icon(Icons.playlist_play_rounded, size: 48, color: AppTheme.gold))
                                  : null,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              pl.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppTheme.fireRed,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Créer', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        onPressed: () => _showCreateDialog(context),
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.queue_music_rounded, size: 72, color: AppTheme.textSecondary),
          const SizedBox(height: 16),
          const Text('Aucune playlist', style: TextStyle(color: AppTheme.textSecondary)),
          const SizedBox(height: 24),
          NeonButton(
            width: 200,
            onPressed: () => _showCreateDialog(context),
            child: const Text('CRÉER UNE PLAYLIST', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1)),
          ),
        ],
      ),
    );
  }

  void _showCreateDialog(BuildContext context) {
    final nameCtrl = TextEditingController();
    String? coverPath;
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.cardBackground,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      isScrollControlled: true,
      builder: (ctx) {
        return StatefulBuilder(builder: (ctx, setSt) {
          return Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom + 24, top: 24, left: 24, right: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('NOUVELLE PLAYLIST', textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 2)),
                const SizedBox(height: 20),
                TextField(
                  controller: nameCtrl,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Nom de la playlist',
                    hintStyle: TextStyle(color: Colors.grey.shade600),
                    filled: true,
                    fillColor: AppTheme.darkBackground,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppTheme.gold, width: 1)),
                  ),
                ),
                const SizedBox(height: 16),
                if (coverPath != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(File(coverPath!), height: 140, fit: BoxFit.cover),
                  )
                else
                  OutlinedButton.icon(
                    icon: const Icon(Icons.image_rounded, color: AppTheme.gold),
                    label: const Text('Ajouter une couverture', style: TextStyle(color: AppTheme.gold)),
                    style: OutlinedButton.styleFrom(side: const BorderSide(color: AppTheme.gold), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    onPressed: () async {
                      final picker = ImagePicker();
                      final picked = await picker.pickImage(source: ImageSource.gallery);
                      if (picked != null) setSt(() => coverPath = picked.path);
                    },
                  ),
                const SizedBox(height: 24),
                NeonButton(
                  onPressed: () {
                    if (nameCtrl.text.trim().isNotEmpty) {
                      context.read<MediaProvider>().createPlaylist(nameCtrl.text.trim(), coverPath);
                      Navigator.pop(ctx);
                    }
                  },
                  child: const Text('CRÉER', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                ),
              ],
            ),
          );
        });
      },
    );
  }
}
