import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../providers/media_provider.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  double _vol = 1.0;

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<MediaProvider>();
    final current = prov.currentMedia;
    if (current == null) {
      return Scaffold(
        backgroundColor: AppTheme.darkBackground,
        appBar: AppBar(leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context))),
        body: const Center(child: Text('Aucune musique en cours', style: TextStyle(color: AppTheme.textSecondary))),
      );
    }

    final dur = prov.duration.inSeconds.toDouble();
    final pos = prov.position.inSeconds.toDouble().clamp(0, dur > 0 ? dur : 0);

    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 32), onPressed: () => Navigator.pop(context)),
        actions: [
          IconButton(
            icon: Icon(prov.isFav(current.id) ? Icons.favorite_rounded : Icons.favorite_border_rounded, color: prov.isFav(current.id) ? AppTheme.fireRed : Colors.white),
            onPressed: () => prov.toggleFavorite(current),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft, end: Alignment.bottomRight,
            colors: [AppTheme.fireRed.withOpacity(0.2), AppTheme.darkBackground, AppTheme.gold.withOpacity(0.1)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Container(
                  width: double.infinity, height: 320,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    gradient: const LinearGradient(colors: [AppTheme.fireRed, AppTheme.gold]),
                    boxShadow: [BoxShadow(color: AppTheme.fireRed.withOpacity(0.3), blurRadius: 30, spreadRadius: 8)],
                  ),
                  child: const Center(child: Icon(Icons.music_note_rounded, size: 120, color: Colors.white70)),
                ),
                const SizedBox(height: 36),
                Text(current.title, textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900)),
                const SizedBox(height: 8),
                Text(current.artist, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppTheme.textSecondary)),
                const Spacer(),
                if (dur > 0)
                  Slider(value: pos, max: dur, onChanged: (v) => prov.seek(Duration(seconds: v.toInt())), activeColor: AppTheme.fireOrange, inactiveColor: Colors.grey.shade800, thumbColor: AppTheme.gold),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_fmt(prov.position), style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                    Text(_fmt(prov.duration), style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.volume_mute_rounded, color: AppTheme.textSecondary, size: 20),
                    Expanded(
                      child: Slider(
                        value: _vol, max: 1.0, divisions: 20,
                        onChanged: (v) {
                          setState(() => _vol = v);
                          prov.setVolume(v);
                        },
                        activeColor: AppTheme.gold, inactiveColor: Colors.grey.shade800, thumbColor: AppTheme.gold,
                      ),
                    ),
                    const Icon(Icons.volume_up_rounded, color: AppTheme.textSecondary, size: 20),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _btn(Icons.skip_previous_rounded, () => prov.previous()),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(colors: [AppTheme.fireRed, AppTheme.fireOrange]),
                        boxShadow: [BoxShadow(color: AppTheme.fireOrange.withOpacity(0.4), blurRadius: 20, spreadRadius: 4)],
                      ),
                      child: IconButton(
                        iconSize: 48, color: Colors.white,
                        icon: Icon(prov.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded),
                        onPressed: () => prov.isPlaying ? prov.pause() : prov.resume(),
                      ),
                    ),
                    _btn(Icons.skip_next_rounded, () => prov.next()),
                  ],
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _btn(IconData icon, VoidCallback onTap) => IconButton(iconSize: 36, color: Colors.white, icon: Icon(icon), onPressed: onTap);
  String _fmt(Duration d) {
    final m = d.inMinutes.toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}
