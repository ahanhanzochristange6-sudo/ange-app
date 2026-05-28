import 'media_item.dart';

class PlaylistModel {
  final int? id;
  final String name;
  final String? coverPath;
  final List<MediaItem> songs;
  final DateTime createdAt;

  PlaylistModel({
    this.id,
    required this.name,
    this.coverPath,
    this.songs = const [],
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'coverPath': coverPath,
    'createdAt': createdAt.millisecondsSinceEpoch,
  };

  factory PlaylistModel.fromMap(Map<String, dynamic> m) => PlaylistModel(
    id: m['id'] as int?,
    name: m['name'] ?? 'Playlist',
    coverPath: m['coverPath'],
    createdAt: DateTime.fromMillisecondsSinceEpoch(m['createdAt'] ?? 0),
  );

  PlaylistModel copyWith({int? id, String? name, String? coverPath, List<MediaItem>? songs}) => PlaylistModel(
    id: id ?? this.id,
    name: name ?? this.name,
    coverPath: coverPath ?? this.coverPath,
    songs: songs ?? this.songs,
    createdAt: createdAt,
  );
}
