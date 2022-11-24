import 'package:flutter/cupertino.dart';
import 'package:music_player_app/providers/db_provider.dart';

class PlaylistProvider extends ChangeNotifier {
  List<MyPlaylistModel> playlists = [];

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
