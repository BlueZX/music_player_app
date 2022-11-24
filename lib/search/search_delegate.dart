import 'package:flutter/material.dart';
import 'package:music_player_app/providers/player_provider.dart';
import 'package:music_player_app/providers/playlist_provider.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class SongSearchDelegate extends SearchDelegate {
  @override
  String get searchFieldLabel => 'Search song';

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      scaffoldBackgroundColor: Colors.grey[700],
      appBarTheme: AppBarTheme(
        //to change appbar
        color: Colors.grey[600],
        elevation: 0,
        titleTextStyle: const TextStyle(
          fontSize: 14,
          color: Color.fromRGBO(255, 255, 255, 0.5),
        ),
        toolbarTextStyle: const TextStyle(
          fontSize: 14,
          color: Color.fromRGBO(255, 255, 255, 0.5),
        ),
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(onPressed: () => query = '', icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return const Text('buildResults');
  }

  Widget _emptyContainer() {
    return const Center(
        child: Icon(
      Icons.music_note,
      color: Colors.black38,
      size: 130,
    ));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return _emptyContainer();
    }

    final playlistProvider =
        Provider.of<PlaylistProvider>(context, listen: false);

    return FutureBuilder(
      future: playlistProvider.searchLocalSongs(query),
      builder: (_, AsyncSnapshot<List<SongModel>> snapshot) {
        if (!snapshot.hasData) return _emptyContainer();

        final songs = snapshot.data!;
        final playerProvider =
            Provider.of<PlayerProvider>(context, listen: false);

        return StreamBuilder<SongModel?>(
            stream: playerProvider.currentSongStream.stream,
            builder: (context, currentSongStream) {
              final indexData = currentSongStream.data;
              return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: songs.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      selected: indexData != null
                          ? indexData.id == songs[index].id
                          : false,
                      selectedTileColor: Colors.black12,
                      leading: Container(
                        width: 55,
                        height: 55,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.black12,
                        ),
                        child: const Icon(
                          Icons.music_note,
                          color: Colors.white70,
                        ),
                      ),
                      title: Text(
                        songs[index].displayNameWOExt,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        songs[index].artist ?? 'Desconocido',
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: Colors.white54,
                            ),
                      ),
                      trailing: const Icon(
                        Icons.keyboard_arrow_right_outlined,
                        color: Colors.white,
                      ),
                      onTap: () {
                        playerProvider.setPlayList(
                            playlistProvider.allSongs,
                            playlistProvider.allSongs
                                .asMap()
                                .keys
                                .toList()
                                .where((i) =>
                                    playlistProvider.allSongs[i].title ==
                                    songs[index].title)
                                .first);
                        if (playerProvider.infoPlaylist.isNotEmpty) {
                          playerProvider.audioPlayer.play();
                        }
                      },
                    );
                  });
            });
      },
    );
  }
}
