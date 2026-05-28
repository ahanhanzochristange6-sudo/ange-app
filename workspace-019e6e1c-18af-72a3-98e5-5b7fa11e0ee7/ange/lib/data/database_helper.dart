import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/media_item.dart';
import '../models/playlist_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  Database? _db;

  Future<Database> get database async {
    _db ??= await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'ange_db.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE playlists (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            coverPath TEXT,
            createdAt INTEGER
          )
        ''');
        await db.execute('''
          CREATE TABLE playlist_songs (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            playlistId INTEGER NOT NULL,
            songId TEXT NOT NULL,
            path TEXT,
            title TEXT,
            artist TEXT,
            durationMs INTEGER
          )
        ''');
        await db.execute('''
          CREATE TABLE favorites (
            id TEXT PRIMARY KEY,
            path TEXT,
            title TEXT,
            artist TEXT,
            type TEXT,
            durationMs INTEGER,
            addedAt INTEGER
          )
        ''');
        await db.execute('''
          CREATE TABLE recents (
            id TEXT PRIMARY KEY,
            path TEXT,
            title TEXT,
            artist TEXT,
            type TEXT,
            durationMs INTEGER,
            playedAt INTEGER
          )
        ''');
      },
    );
  }

  // Playlists
  Future<int> insertPlaylist(PlaylistModel p) async {
    final db = await database;
    return db.insert('playlists', p.toMap());
  }

  Future<void> updatePlaylist(PlaylistModel p) async {
    final db = await database;
    await db.update('playlists', p.toMap(), where: 'id = ?', whereArgs: [p.id]);
  }

  Future<void> deletePlaylist(int id) async {
    final db = await database;
    await db.delete('playlists', where: 'id = ?', whereArgs: [id]);
    await db.delete('playlist_songs', where: 'playlistId = ?', whereArgs: [id]);
  }

  Future<List<PlaylistModel>> getPlaylists() async {
    final db = await database;
    final maps = await db.query('playlists', orderBy: 'createdAt DESC');
    final playlists = maps.map((m) => PlaylistModel.fromMap(m)).toList();
    for (final p in playlists) {
      p.songs.addAll(await getPlaylistSongs(p.id!));
    }
    return playlists;
  }

  Future<void> addSongToPlaylist(int playlistId, MediaItem song) async {
    final db = await database;
    await db.insert('playlist_songs', {
      'playlistId': playlistId,
      'songId': song.id,
      'path': song.path,
      'title': song.title,
      'artist': song.artist,
      'durationMs': song.durationMs,
    });
  }

  Future<void> removeSongFromPlaylist(int playlistId, String songId) async {
    final db = await database;
    await db.delete('playlist_songs', where: 'playlistId = ? AND songId = ?', whereArgs: [playlistId, songId]);
  }

  Future<List<MediaItem>> getPlaylistSongs(int playlistId) async {
    final db = await database;
    final maps = await db.query('playlist_songs', where: 'playlistId = ?', whereArgs: [playlistId]);
    return maps.map((m) => MediaItem(
      id: m['songId'] as String,
      path: m['path'] as String,
      title: m['title'] as String,
      artist: m['artist'] as String? ?? '',
      type: 'music',
      durationMs: m['durationMs'] as int? ?? 0,
    )).toList();
  }

  // Favorites
  Future<void> toggleFavorite(MediaItem item) async {
    final db = await database;
    final existing = await db.query('favorites', where: 'id = ?', whereArgs: [item.id]);
    if (existing.isNotEmpty) {
      await db.delete('favorites', where: 'id = ?', whereArgs: [item.id]);
    } else {
      await db.insert('favorites', {
        'id': item.id,
        'path': item.path,
        'title': item.title,
        'artist': item.artist,
        'type': item.type,
        'durationMs': item.durationMs,
        'addedAt': DateTime.now().millisecondsSinceEpoch,
      });
    }
  }

  Future<bool> isFavorite(String id) async {
    final db = await database;
    final res = await db.query('favorites', where: 'id = ?', whereArgs: [id]);
    return res.isNotEmpty;
  }

  Future<List<MediaItem>> getFavorites() async {
    final db = await database;
    final maps = await db.query('favorites', orderBy: 'addedAt DESC');
    return maps.map((m) => MediaItem.fromMap({
      ...m,
      'dateAdded': m['addedAt'],
    })).toList();
  }

  // Recents
  Future<void> addRecent(MediaItem item) async {
    final db = await database;
    await db.insert('recents', {
      'id': item.id,
      'path': item.path,
      'title': item.title,
      'artist': item.artist,
      'type': item.type,
      'durationMs': item.durationMs,
      'playedAt': DateTime.now().millisecondsSinceEpoch,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<MediaItem>> getRecents() async {
    final db = await database;
    final maps = await db.query('recents', orderBy: 'playedAt DESC', limit: 50);
    return maps.map((m) => MediaItem.fromMap({
      ...m,
      'dateAdded': m['playedAt'],
    })).toList();
  }
}
