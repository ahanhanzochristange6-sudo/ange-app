import 'package:on_audio_query/on_audio_query.dart';

class MediaItem {
  final String id;
  final String path;
  final String title;
  final String artist;
  final String album;
  final String type; // 'music' | 'video'
  final int durationMs;
  final String? artUri;
  final DateTime? dateAdded;

  MediaItem({
    required this.id,
    required this.path,
    required this.title,
    this.artist = '',
    this.album = '',
    required this.type,
    this.durationMs = 0,
    this.artUri,
    this.dateAdded,
  });

  factory MediaItem.fromSongModel(SongModel s) {
    return MediaItem(
      id: s.id.toString(),
      path: s.data,
      title: s.title,
      artist: s.artist ?? 'Artiste inconnu',
      album: s.album ?? 'Album inconnu',
      type: 'music',
      durationMs: s.duration ?? 0,
      dateAdded: s.dateAdded != null ? DateTime.fromMillisecondsSinceEpoch(s.dateAdded!) : null,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'path': path,
    'title': title,
    'artist': artist,
    'album': album,
    'type': type,
    'durationMs': durationMs,
    'artUri': artUri,
    'dateAdded': dateAdded?.millisecondsSinceEpoch,
  };

  factory MediaItem.fromMap(Map<String, dynamic> m) => MediaItem(
    id: m['id'] ?? '',
    path: m['path'] ?? '',
    title: m['title'] ?? 'Sans titre',
    artist: m['artist'] ?? '',
    album: m['album'] ?? '',
    type: m['type'] ?? 'music',
    durationMs: m['durationMs'] ?? 0,
    artUri: m['artUri'],
    dateAdded: m['dateAdded'] != null ? DateTime.fromMillisecondsSinceEpoch(m['dateAdded']) : null,
  );

  String get displayDuration {
    final sec = (durationMs ~/ 1000);
    final m = sec ~/ 60;
    final s = sec % 60;
    return '${m.toString().padLeft(2,'0')}:${s.toString().padLeft(2,'0')}';
  }

  MediaItem copyWith({String? path, String? title, String? artist, String? artUri}) => MediaItem(
    id: id,
    path: path ?? this.path,
    title: title ?? this.title,
    artist: artist ?? this.artist,
    album: album,
    type: type,
    durationMs: durationMs,
    artUri: artUri ?? this.artUri,
    dateAdded: dateAdded,
  );
}
