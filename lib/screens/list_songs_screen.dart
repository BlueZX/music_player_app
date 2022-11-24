import 'dart:io';

import 'package:flutter/material.dart';
import 'package:music_player_app/providers/player_provider.dart';
import 'package:on_audio_query/on_audio_query.dart';

class ListSongsScreen extends StatelessWidget {
  final PlayerProvider playerProvider;
  const ListSongsScreen({
    Key? key,
    required this.playerProvider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(20, 20, 20, 0.8),
              Color.fromRGBO(66, 66, 66, 1),
            ]),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: const Text('Tu Biblioteca'),
          actions: [
            Container(
                margin: const EdgeInsets.only(right: 10),
                child: IconButton(
                    onPressed: () {}, icon: const Icon(Icons.search)))
          ],
        ),
        body: _ListSongsContent(playerProvider: playerProvider),
      ),
    );
  }
}

class _ListSongsContent extends StatefulWidget {
  final PlayerProvider playerProvider;
  const _ListSongsContent({Key? key, required this.playerProvider})
      : super(key: key);

  @override
  State<_ListSongsContent> createState() => _ListSongsContentState();
}

class _ListSongsContentState extends State<_ListSongsContent> {
  final OnAudioQuery _audioQuery = OnAudioQuery();

  void playSong(PlayerProvider playerProvider, [int? index]) {
    try {
      if (!playerProvider.audioPlayer.playing) {
        playerProvider.audioPlayer.play();
        print('sonando: ${playerProvider.audioPlayer.playing}');
      }

      // Navigator.pushNamed(context, 'player',
      //     arguments: {'song': song, 'audioPlayer': audioPlayer});

      // }
    } on Exception {
      print('Error parsing song');
    }
  }

  requestPermission() async {
    if (Platform.isAndroid) {
      bool permissionStatus = await _audioQuery.permissionsStatus();
      if (!permissionStatus) {
        await _audioQuery.permissionsRequest();
      }
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    requestPermission();
  }

  Future<List<SongModel>> songsMp3() async {
    List<SongModel> allSongs = await _audioQuery.querySongs(
      sortType: null,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );

    return allSongs
        .where((song) => song.fileExtension == 'mp3' && song.duration! > 30000)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SongModel>>(
      future: songsMp3(),
      builder: ((context, item) {
        if (item.data == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (item.data!.isEmpty) {
          return const Text('No se encontraron canciones :c');
        }

        return StreamBuilder<SongModel?>(
            stream: widget.playerProvider.currentSongStream.stream,
            builder: (context, currentSongStream) {
              final indexData = currentSongStream.data;
              return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: item.data?.length ?? 0,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      selected: indexData != null
                          ? indexData.id == item.data![index].id
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
                        item.data![index].displayNameWOExt,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        item.data![index].artist ?? 'Desconocido',
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
                        widget.playerProvider.setPlayList(item.data!, index);
                        if (widget.playerProvider.infoPlaylist.isNotEmpty) {
                          playSong(widget.playerProvider, index);
                        }
                      },
                    );
                  });
            });
      }),
    );
  }
}
