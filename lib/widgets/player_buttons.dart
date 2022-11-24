import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player_app/providers/player_provider.dart';

class PlayerButtons extends StatelessWidget {
  final PlayerProvider playerProvider;

  const PlayerButtons({
    Key? key,
    required this.playerProvider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        StreamBuilder<bool>(
            stream: playerProvider.audioPlayer.shuffleModeEnabledStream,
            builder: (context, enabled) {
              final enabledData = enabled.data ?? false;
              return IconButton(
                iconSize: 30,
                onPressed: () => playerProvider.audioPlayer
                    .setShuffleModeEnabled(!enabledData),
                icon: Icon(
                  enabledData
                      ? Icons.shuffle_on_outlined
                      : Icons.shuffle_outlined,
                  color: Colors.white,
                ),
              );
            }),
        const SizedBox(width: 7),
        StreamBuilder<SequenceState?>(
          stream: playerProvider.audioPlayer.sequenceStateStream,
          builder: (context, sequence) {
            return IconButton(
              iconSize: 62.0,
              onPressed: playerProvider.audioPlayer.hasPrevious
                  ? () {
                      playerProvider
                          .setId(playerProvider.audioPlayer.previousIndex);
                      playerProvider.audioPlayer.seekToPrevious();
                    }
                  : null,
              icon: const Icon(
                Icons.skip_previous,
                color: Colors.white,
              ),
            );
          },
        ),
        StreamBuilder<PlayerState>(
          stream: playerProvider.audioPlayer.playerStateStream,
          builder: (context, player) {
            if (player.hasData) {
              final playerState = player.data;
              final processingState = playerState!.processingState;
              if (processingState == ProcessingState.loading ||
                  processingState == ProcessingState.buffering) {
                return const IconButton(
                  iconSize: 62.0,
                  onPressed: null,
                  icon: Icon(
                    Icons.play_circle,
                    color: Colors.white,
                  ),
                );
              } else if (!playerProvider.audioPlayer.playing) {
                return IconButton(
                  iconSize: 62.0,
                  color: Colors.white,
                  onPressed: playerProvider.audioPlayer.play,
                  icon: const Icon(Icons.play_circle),
                );
              } else if (processingState != ProcessingState.completed) {
                return IconButton(
                  iconSize: 62.0,
                  color: Colors.white,
                  onPressed: playerProvider.audioPlayer.pause,
                  icon: const Icon(Icons.pause_circle),
                );
              } else {
                return IconButton(
                  iconSize: 62.0,
                  color: Colors.white,
                  onPressed: () => playerProvider.audioPlayer.seek(
                    Duration.zero,
                    index: playerProvider.audioPlayer.effectiveIndices!.first,
                  ),
                  icon: const Icon(Icons.play_circle),
                );
              }
            }

            return const CircularProgressIndicator();
          },
        ),
        StreamBuilder<SequenceState?>(
          stream: playerProvider.audioPlayer.sequenceStateStream,
          builder: (context, sequence) {
            return IconButton(
              iconSize: 62.0,
              onPressed: playerProvider.audioPlayer.hasNext
                  ? () {
                      playerProvider
                          .setId(playerProvider.audioPlayer.nextIndex);
                      playerProvider.audioPlayer.seekToNext();
                    }
                  : null,
              icon: const Icon(
                Icons.skip_next,
                color: Colors.white,
              ),
            );
          },
        ),
        const SizedBox(width: 10),
        StreamBuilder<LoopMode>(
            stream: playerProvider.audioPlayer.loopModeStream,
            builder: (context, loopMode) {
              final loopModeData = loopMode.data ?? LoopMode.off;
              return IconButton(
                iconSize: 30,
                onPressed: () {
                  switch (loopModeData) {
                    case LoopMode.off:
                      playerProvider.audioPlayer.setLoopMode(LoopMode.all);
                      break;
                    case LoopMode.all:
                      playerProvider.audioPlayer.setLoopMode(LoopMode.one);
                      break;
                    default:
                      playerProvider.audioPlayer.setLoopMode(LoopMode.off);
                      break;
                  }
                },
                icon: Icon(
                  loopModeData == LoopMode.all
                      ? Icons.repeat_on_outlined
                      : (loopModeData == LoopMode.one
                          ? Icons.repeat_one_on_outlined
                          : Icons.repeat_outlined),
                  color: Colors.white,
                ),
              );
            }),
      ],
    );
  }
}
