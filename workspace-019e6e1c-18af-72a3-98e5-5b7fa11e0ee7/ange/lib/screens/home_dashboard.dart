import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import '../core/theme.dart';
import '../providers/media_provider.dart';
import '../widgets/glass_card.dart';
import '../widgets/gradient_text.dart';
import 'music_screen.dart';
import 'video_screen.dart';
import 'player_screen.dart';
import 'video_player_screen.dart';
import 'recent_screen.dart';

class HomeDashboard extends StatelessWidget {
  const HomeDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<MediaProvider>();
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.asset('assets/images/icon.png', width: 48, height: 48),
                      const SizedBox(width: 12),
                      const GradientText('ANGE', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: 4)),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.search, color: AppTheme.gold),
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SearchScreen())),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  if (prov.recents.isNotEmpty) ...[
                    const Text('RÉCEMMENT', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, letterSpacing: 2, color: AppTheme.textSecondary)),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 140,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: prov.recents.take(10).length,
                        itemBuilder: (ctx, i) {
                          final item = prov.recents[i];
                          return FadeInLeft(
                            delay: Duration(milliseconds: i * 100),
                            child: GestureDetector(
                              onTap: () {
                                if (item.type == 'music') Navigator.push(ctx, MaterialPageRoute(builder: (_) => const PlayerScreen()));
                                else Navigator.push(ctx, MaterialPageRoute(builder: (_) => VideoPlayerScreen(item: item)));
                              },
                              child: Container(
                                width: 120,
                                margin: const EdgeInsets.only(right: 12),
                                child: GlassCard(
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: AppTheme.fireRed.withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Center(
                                            child: Icon(item.type == 'music' ? Icons.music_note : Icons.videocam, color: AppTheme.gold),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  const Text('CATÉGORIES', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, letterSpacing: 2, color: AppTheme.textSecondary)),
                  const SizedBox(height: 12),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.4,
                    children: [
                      _buildCategoryTile(context, 'Musique', Icons.music_note_rounded, AppTheme.fireRed, const MusicScreen()),
                      _buildCategoryTile(context, 'Films', Icons.videocam_rounded, AppTheme.fireOrange, const VideoScreen()),
                      _buildCategoryTile(context, 'Favoris', Icons.favorite_rounded, AppTheme.gold, const FavoritesScreen()),
                      _buildCategoryTile(context, 'Récent', Icons.history_rounded, Colors.redAccent, const RecentScreen()),
                    ],
                  ),
                  const SizedBox(height: 24),
                  if (prov.currentMedia != null) ...[
                    const Text('LECTURE EN COURS', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, letterSpacing: 2, color: AppTheme.textSecondary)),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PlayerScreen())),
                      child: GlassCard(
                        child: Row(
                          children: [
                            Container(
                              width: 48, height: 48,
                              decoration: BoxDecoration(color: AppTheme.fireRed.withOpacity(0.3), borderRadius: BorderRadius.circular(12)),
                              child: const Icon(Icons.music_note, color: AppTheme.gold),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(prov.currentMedia!.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold)),
                                  Text(prov.currentMedia!.artist, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: Icon(prov.isPlaying ? Icons.pause_circle_filled_rounded : Icons.play_circle_fill_rounded, color: AppTheme.gold, size: 36),
                              onPressed: () => prov.isPlaying ? prov.pause() : prov.resume(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTile(BuildContext context, String label, IconData icon, Color color, Widget page) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 36),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, letterSpacing: 1)),
          ],
        ),
      ),
    );
  }
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String query = '';

  @override
  Widget build(BuildContext context) {
    final prov = context.read<MediaProvider>();
    final results = query.isEmpty ? <dynamic>[] : prov.search(query);
    return Scaffold(
      appBar: AppBar(
        title: const Text('RECHERCHE'),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              autofocus: true,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Rechercher musique ou film...',
                hintStyle: TextStyle(color: Colors.grey.shade600),
                prefixIcon: const Icon(Icons.search, color: AppTheme.gold),
                filled: true,
                fillColor: AppTheme.cardBackground,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppTheme.gold, width: 1)),
              ),
              onChanged: (v) => setState(() => query = v),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: results.isEmpty
                  ? Center(child: Text(query.isEmpty ? 'Tapez pour rechercher' : 'Aucun résultat', style: const TextStyle(color: AppTheme.textSecondary)))
                  : ListView.builder(
                      itemCount: results.length,
                      itemBuilder: (ctx, i) {
                        final item = results[i] as dynamic;
                        return ListTile(
                          leading: Icon(item.type == 'music' ? Icons.music_note : Icons.videocam, color: AppTheme.gold),
                          title: Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                          subtitle: Text(item.artist ?? '', maxLines: 1, overflow: TextOverflow.ellipsis),
                          trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppTheme.textSecondary),
                          onTap: () {
                            if (item.type == 'music') {
                              prov.playMusic(item);
                              Navigator.push(ctx, MaterialPageRoute(builder: (_) => const PlayerScreen()));
                            } else {
                              Navigator.push(ctx, MaterialPageRoute(builder: (_) => VideoPlayerScreen(item: item)));
                            }
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
