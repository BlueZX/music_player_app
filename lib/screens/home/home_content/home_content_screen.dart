import 'package:flutter/material.dart';
import 'package:music_player_app/providers/player_provider.dart';
import 'package:music_player_app/widgets/widgets.dart';
import 'package:on_audio_query/on_audio_query.dart';

class HomeContentScreen extends StatelessWidget {
  final OnAudioQuery audioQuery;
  final PlayerProvider playerProvider;

  const HomeContentScreen({
    Key? key,
    required this.audioQuery,
    required this.playerProvider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final List<List<SongModel>> playlists = [
    //   [
    //     SongModel({
    //       '_id': 0,
    //       'album': 'Online',
    //       'title': 'Tristram',
    //       "artist": 'random',
    //       'albumId':
    //           'https://upload.wikimedia.org/wikipedia/en/3/3a/Diablo_Coverart.png',
    //       '_uri':
    //           "https://archive.org/download/IGM-V7/IGM%20-%20Vol.%207/25%20Diablo%20-%20Tristram%20%28Blizzard%29.mp3",
    //     }),
    //     SongModel({
    //       '_id': 1,
    //       'album': 'Online',
    //       "artist": 'random 2',
    //       'title': 'Cerulean Cit',
    //       'albumId':
    //           'https://upload.wikimedia.org/wikipedia/en/f/f1/Bulbasaur_pokemon_red.png',
    //       '_uri':
    //           "https://archive.org/download/igm-v8_202101/IGM%20-%20Vol.%208/15%20Pokemon%20Red%20-%20Cerulean%20City%20%28Game%20Freak%29.mp3",
    //     })
    //   ],
    // ];

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text('Music Player'),
        actions: [
          Container(
              margin: const EdgeInsets.only(right: 10),
              child: IconButton(
                  onPressed: () {}, icon: const Icon(Icons.search_outlined)))
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const PlaylistSlider(),
            ListSongs(
              audioQuery: audioQuery,
              playerProvider: playerProvider,
            ),
            const SizedBox(
              height: 60,
            ),
          ],
        ),
      ),
    );
  }
}
