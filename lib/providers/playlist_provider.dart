import 'package:flutter/cupertino.dart';
import 'package:music_player_app/providers/db_provider.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlaylistProvider extends ChangeNotifier {
  List<MyPlaylistModel> playlists = [];
  final OnAudioQuery _audioQuery = OnAudioQuery();
  List<SongModel> _allSongs = [];

  OnAudioQuery get audioQuery => _audioQuery;
  List<SongModel> get allSongs => _allSongs;

  Future<List<SongModel>> loadAllLocalSongs() async {
    List<SongModel> songs = await _audioQuery.querySongs(
      sortType: null,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );

    _allSongs = songs
        .where((song) => song.fileExtension == 'mp3' && song.duration! > 30000)
        .toList();

    return _allSongs;
  }

  Future<List<SongModel>> searchLocalSongs(String filter) async {
    List<SongModel> songs =
        _allSongs.isNotEmpty ? _allSongs : await loadAllLocalSongs();

    return songs
        .where(
            (song) => song.title.toLowerCase().contains(filter.toLowerCase()))
        .toList();
  }

  newPlaylist(MyPlaylistModel newPlaylist) async {
    await DBProvider.db.newPlaylist(newPlaylist);
    playlists.add(newPlaylist);
    notifyListeners();
  }

  loadPlaylists() async {
    final playlists = await DBProvider.db.getPlaylistsWithSongs();

    if (playlists != null) {
      if (playlists.isEmpty) {
        await newPlaylist(
          MyPlaylistModel(
              id: 1,
              name: 'Tus me gusta',
              cover:
                  'https://i0.wp.com/olumuse.org/wp-content/uploads/2020/09/unnamed.jpg?fit=512%2C512&ssl=1',
              songs: []),
        );
      } else {
        this.playlists = [...playlists];
        notifyListeners();
      }
    }
  }

  addAndRemoveToFavorite(MySongModel song) async {
    final allSongFavorite = await DBProvider.db.getSongs(1);

    if (allSongFavorite != null) {
      if (allSongFavorite
          .where((favorite) => favorite.uri == song.uri)
          .isEmpty) {
        await DBProvider.db.newSong(song);
        playlists[0].songs = [...playlists[0].songs, song];
        notifyListeners();
      } else {
        await DBProvider.db.deleteSong(1, song.uri);
        playlists[0].songs =
            playlists[0].songs.where((s) => s.uri != song.uri).toList();
        notifyListeners();
      }
    }
  }
}
