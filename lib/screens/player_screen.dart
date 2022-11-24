import 'package:flutter/material.dart';
import 'package:music_player_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

import '../providers/player_provider.dart';

class PlayerScreen extends StatelessWidget {
  const PlayerScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // final Map<String, dynamic> args =
    // ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    // final SongModel song = args['song'];
    // final AudioPlayer audioPlayer = args['audioPlayer'];

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: kToolbarHeight * 2,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.keyboard_arrow_down_outlined)),
        title: Column(
          children: const [
            Text('Reproduciendo desde tu biblioteca',
                style: TextStyle(
                  fontSize: 14,
                  color: Color.fromRGBO(255, 255, 255, 0.5),
                )),
            Text('Archivos locales'),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {}, icon: const Icon(Icons.more_horiz_outlined))
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/cover.jpg',
            fit: BoxFit.cover,
          ),
          const _BackgroundFilter(),
          _MusicPlayer(size: size),
        ],
      ),
    );
  }
}

class _MusicPlayer extends StatelessWidget {
  final Size size;

  const _MusicPlayer({
    Key? key,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final playerProvider = Provider.of<PlayerProvider>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: StreamBuilder<int?>(
          stream: playerProvider.audioPlayer.currentIndexStream,
          builder: (context, index) {
            final songData =
                playerProvider.infoPlaylist[index.data ?? playerProvider.id];
            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  songData.title,
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  songData.artist != '<unknown>'
                      ? songData.artist!
                      : 'Artista desconocido',
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Colors.white,
                      ),
                ),
                const SizedBox(
                  height: 25,
                ),
                StreamBuilder(
                  stream: playerProvider.audioPlayer.positionStream,
                  builder: (_, position) {
                    final positionData = position.data ?? Duration.zero;
                    return StreamBuilder(
                      stream: playerProvider.audioPlayer.durationStream,
                      builder: (_, duration) {
                        final durationData = duration.data ?? Duration.zero;
                        return SeekBar(
                          position: positionData,
                          duration: durationData,
                          onChangeEnd: playerProvider.audioPlayer.seek,
                        );
                      },
                    );
                  },
                ),
                PlayerButtons(playerProvider: playerProvider),
              ],
            );
          }),
    );
  }
}

class _BackgroundFilter extends StatelessWidget {
  const _BackgroundFilter({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (rect) => LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white,
            Colors.white.withOpacity(0.5),
            Colors.white.withOpacity(0.0),
          ],
          stops: const [
            0.0,
            0.4,
            0.6
          ]).createShader(rect),
      blendMode: BlendMode.dstOut,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromRGBO(66, 66, 66, 1),
                Color.fromRGBO(20, 20, 20, 1),
              ]),
        ),
      ),
    );
  }
}
