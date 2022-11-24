import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:music_player_app/providers/db_provider.dart';
import 'package:music_player_app/providers/player_provider.dart';
import 'package:music_player_app/providers/playlist_provider.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class ListSongs extends StatelessWidget {
  final String? title;

  const ListSongs({
    Key? key,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final playerProvider = Provider.of<PlayerProvider>(context);
    final playlistProvider = Provider.of<PlaylistProvider>(context);

    final List<SongModel>? myLiked = playlistProvider.playlists.isNotEmpty
        ? playlistProvider.playlists[0].songs
        : null;

    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: AutoSizeText(
              title ?? 'Todas las canciones',
              style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          FutureBuilder<List<SongModel>>(
            future: playlistProvider.loadAllLocalSongs(),
            builder: ((context, item) {
              if (item.data == null || myLiked == null) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                );
              }
              if (item.data!.isEmpty) {
                return const Center(
                    child: Text('No se encontraron canciones :c'));
              }
              return StreamBuilder<SongModel?>(
                stream: playerProvider.currentSongStream.stream,
                builder: (context, currentSongStream) {
                  final indexData = currentSongStream.data;
                  print('id: ${indexData?.id}');

                  return Column(
                    children: <Widget>[
                      ...item.data!
                          .asMap()
                          .entries
                          .map(
                            (song) => ListTile(
                              selected: indexData != null
                                  ? indexData.id == song.value.id
                                  : false,
                              selectedTileColor: Colors.white24,
                              dense: true,
                              minLeadingWidth: 20,
                              horizontalTitleGap: 10,
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
                                song.value.title,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                              ),
                              subtitle: Text(
                                song.value.artist != null &&
                                        song.value.artist != '<unknown>'
                                    ? song.value.artist!
                                    : 'Artista desconocido',
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                      color: Colors.white54,
                                    ),
                              ),
                              trailing: IconButton(
                                icon: Icon(
                                  Icons.heart_broken_sharp,
                                  color: myLiked
                                          .where((f) => f.uri == song.value.uri)
                                          .isNotEmpty
                                      ? Colors.red[300]
                                      : Colors.white30,
                                ),
                                onPressed: () {
                                  playlistProvider
                                      .addAndRemoveToFavorite(MySongModel({
                                    '_id': song.value.id,
                                    'album': song.value.album,
                                    'title': song.value.title,
                                    "artist": song.value.artist,
                                    'albumId': song.value.albumId,
                                    '_uri': song.value.uri,
                                  }));
                                },
                              ),
                              onTap: () {
                                playerProvider.setPlayList(
                                    item.data!, song.key);
                                if (playerProvider.infoPlaylist.isNotEmpty) {
                                  playerProvider.audioPlayer.play();
                                }
                              },
                            ),
                          )
                          .toList(),
                    ],
                  );
                },
              );
            }),
          )
        ],
      ),
    );
  }
}
