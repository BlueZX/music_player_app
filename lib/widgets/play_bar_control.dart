import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:music_player_app/providers/player_provider.dart';

class PlayBarControl extends StatelessWidget {
  final PlayerProvider playerProvider;
  final SongModel songData;

  const PlayBarControl({
    Key? key,
    required this.playerProvider,
    required this.songData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 55,
      color: Colors.black26,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 7),
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.black12,
                ),
                child: const Icon(
                  Icons.music_note,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(
                width: 2,
              ),
              SizedBox(
                width: 220,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      songData.title,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      songData.artist != '<uknown>'
                          ? songData.artist!
                          : 'Desconocido',
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Colors.white54,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.heart_broken,
                    size: 30,
                  ),
                  color: Colors.white,
                ),
                const SizedBox(
                  width: 2,
                ),
                StreamBuilder<PlayerState>(
                  stream: playerProvider.audioPlayer.playerStateStream,
                  builder: (context, player) {
                    if (player.hasData) {
                      if (!playerProvider.audioPlayer.playing) {
                        return IconButton(
                          iconSize: 35,
                          color: Colors.white,
                          onPressed: playerProvider.audioPlayer.play,
                          icon: const Icon(Icons.play_arrow),
                        );
                      } else {
                        return IconButton(
                          iconSize: 35,
                          color: Colors.white,
                          onPressed: playerProvider.audioPlayer.pause,
                          icon: const Icon(Icons.pause),
                        );
                      }
                    }

                    return const CircularProgressIndicator();
                  },
                ),
              ])
        ],
      ),
    );
  }
}
