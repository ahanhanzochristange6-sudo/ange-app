import 'package:flutter/material.dart';
import 'home_dashboard.dart';
import 'music_screen.dart';
import 'video_screen.dart';
import 'playlists_screen.dart';
import 'favorites_screen.dart';
import '../core/theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomeDashboard(),
    MusicScreen(),
    VideoScreen(),
    PlaylistsScreen(),
    FavoritesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _pages[_currentIndex],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppTheme.cardBackground.withOpacity(0.9),
          border: Border(top: BorderSide(color: AppTheme.fireRed.withOpacity(0.3), width: 1)),
          boxShadow: [BoxShadow(color: AppTheme.fireRed.withOpacity(0.15), blurRadius: 12)],
        ),
        child: SafeArea(
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (i) => setState(() => _currentIndex = i),
            backgroundColor: Colors.transparent,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: AppTheme.gold,
            unselectedItemColor: AppTheme.textSecondary,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Accueil'),
              BottomNavigationBarItem(icon: Icon(Icons.music_note_rounded), label: 'Musique'),
              BottomNavigationBarItem(icon: Icon(Icons.videocam_rounded), label: 'Films'),
              BottomNavigationBarItem(icon: Icon(Icons.playlist_play_rounded), label: 'Playlists'),
              BottomNavigationBarItem(icon: Icon(Icons.favorite_rounded), label: 'Favoris'),
            ],
          ),
        ),
      ),
    );
  }
}
