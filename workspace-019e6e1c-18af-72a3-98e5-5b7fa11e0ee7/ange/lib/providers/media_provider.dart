import 'dart:async';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../models/media_item.dart';
import '../models/playlist_model.dart';
import '../data/database_helper.dart';
import '../services/media_scanner.dart';

class MediaProvider extends ChangeNotifier {
  final MediaScanner _scanner = MediaScanner();
  final DatabaseHelper _db = DatabaseHelper();
  final AudioPlayer _player = AudioPlayer();

  List<MediaItem> music = [];
  List<MediaItem> videos = [];
  List<MediaItem> favorites = [];
  List<MediaItem> recents = [];
  List<PlaylistModel> playlists = [];

  MediaItem? currentMedia;
  List<MediaItem> currentQueue = [];
  int currentIndex = 0;
  bool isPlaying = false;
  Duration position = Duration.zero;
  Duration duration = Duration.zero;
  bool isLoading = true;

  StreamSubscription? _posSub;
  StreamSubscription? _durSub;
  StreamSubscription? _stateSub;

  MediaProvider() {
    _initPlayerStreams();
  }

  void _initPlayerStreams() {
    _posSub = _player.positionStream.listen((p) {
      position = p;
      notifyListeners();
    });
    _durSub = _player.durationStream.listen((d) {
      duration = d ?? Duration.zero;
      notifyListeners();
    });
    _stateSub = _player.playerStateStream.listen((state) {
      isPlaying = state.playing;
      if (state.processingState == ProcessingState.completed) {
        next();
      }
      notifyListeners();
    });
  }

  Future<void> loadData() async {
    isLoading = true;
    notifyListeners();
    await Future.wait([
      _loadMusic(),
      _loadVideos(),
      _loadPlaylists(),
      _loadFavorites(),
      _loadRecents(),
    ]);
    isLoading = false;
    notifyListeners();
  }

  Future<void> refresh() async {
    await loadData();
  }

  Future<void> _loadMusic() async {
    music = await _scanner.scanMusic();
  }

  Future<void> _loadVideos() async {
    videos = await _scanner.scanVideos();
  }

  Future<void> _loadPlaylists() async {
    playlists = await _db.getPlaylists();
  }

  Future<void> _loadFavorites() async {
    favorites = await _db.getFavorites();
  }

  Future<void> _loadRecents() async {
    recents = await _db.getRecents();
  }

  Future<void> playMusic(MediaItem item, {List<MediaItem>? queue, int? index}) async {
    if (queue != null && queue.isNotEmpty) {
      currentQueue = queue;
      currentIndex = index ?? queue.indexWhere((q) => q.id == item.id);
      if (currentIndex < 0) currentIndex = 0;
    } else {
      currentQueue = [item];
      currentIndex = 0;
    }
    currentMedia = currentQueue[currentIndex];
    notifyListeners();
    try {
      await _player.setFilePath(currentMedia!.path);
      await _player.play();
      await _db.addRecent(currentMedia!);
      await _loadRecents();
    } catch (e) {
      debugPrint('Erreur lecture: $e');
    }
    notifyListeners();
  }

  void pause() => _player.pause();
  void resume() => _player.play();
  void seek(Duration pos) => _player.seek(pos);
  void setVolume(double v) => _player.setVolume(v);

  void next() {
    if (currentQueue.isEmpty) return;
    if (currentIndex < currentQueue.length - 1) {
      currentIndex++;
      playMusic(currentQueue[currentIndex], queue: currentQueue, index: currentIndex);
    }
  }

  void previous() {
    if (currentQueue.isEmpty) return;
    if (currentIndex > 0) {
      currentIndex--;
      playMusic(currentQueue[currentIndex], queue: currentQueue, index: currentIndex);
    }
  }

  Future<void> toggleFavorite(MediaItem item) async {
    await _db.toggleFavorite(item);
    await _loadFavorites();
    notifyListeners();
  }

  bool isFav(String id) => favorites.any((f) => f.id == id);

  Future<void> createPlaylist(String name, String? coverPath) async {
    final p = PlaylistModel(name: name, coverPath: coverPath, createdAt: DateTime.now());
    await _db.insertPlaylist(p);
    await _loadPlaylists();
    notifyListeners();
  }

  Future<void> addToPlaylist(int playlistId, MediaItem song) async {
    await _db.addSongToPlaylist(playlistId, song);
    await _loadPlaylists();
    notifyListeners();
  }

  Future<void> removeFromPlaylist(int playlistId, String songId) async {
    await _db.removeSongFromPlaylist(playlistId, songId);
    await _loadPlaylists();
    notifyListeners();
  }

  Future<void> deletePlaylist(int id) async {
    await _db.deletePlaylist(id);
    await _loadPlaylists();
    notifyListeners();
  }

  List<MediaItem> search(String query) {
    final q = query.toLowerCase();
    return [
      ...music.where((m) => m.title.toLowerCase().contains(q) || m.artist.toLowerCase().contains(q)),
      ...videos.where((v) => v.title.toLowerCase().contains(q)),
    ];
  }

  @override
  void dispose() {
    _posSub?.cancel();
    _durSub?.cancel();
    _stateSub?.cancel();
    _player.dispose();
    super.dispose();
  }
}
