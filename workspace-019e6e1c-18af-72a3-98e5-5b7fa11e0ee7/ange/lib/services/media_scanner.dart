import 'package:on_audio_query/on_audio_query.dart';
import 'package:photo_manager/photo_manager.dart';
import '../models/media_item.dart';

class MediaScanner {
  final OnAudioQuery _audioQuery = OnAudioQuery();

  Future<List<MediaItem>> scanMusic() async {
    try {
      bool permitted = await _audioQuery.permissionsRequest(retryRequest: true);
      if (!permitted) return [];
      final songs = await _audioQuery.querySongs(
        sortType: SongSortType.TITLE,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
        ignoreCase: true,
      );
      return songs.map((s) => MediaItem.fromSongModel(s)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<MediaItem>> scanVideos() async {
    try {
      final PermissionState ps = await PhotoManager.requestPermissionExtend(requestOption: const PermissionRequestOption(
        androidPermission: AndroidPermission(type: RequestType.video, mediaLocation: false),
      ));
      if (!ps.isAuth) return [];
      final List<AssetEntity> entities = await PhotoManager.getAssetListRange(
        start: 0, end: 500, type: RequestType.video,
      );
      final List<MediaItem> items = [];
      for (final e in entities) {
        final file = await e.file;
        if (file != null) {
          items.add(MediaItem(
            id: e.id,
            path: file.path,
            title: e.title ?? 'Vidéo sans titre',
            artist: '',
            type: 'video',
            durationMs: e.videoDuration ?? 0,
            dateAdded: e.createDateTime,
          ));
        }
      }
      return items;
    } catch (e) {
      return [];
    }
  }
}
