import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:music_player_app/models/playlist_model.dart';
import 'package:music_player_app/providers/player_provider.dart';

class PlaylistScreen extends StatefulWidget {
  final MyPlaylistModel playlist;
  final PlayerProvider playerProvider;
  const PlaylistScreen({
    Key? key,
    required this.playlist,
    required this.playerProvider,
  }) : super(key: key);

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  late ScrollController _scrollController;
  bool lastStatus = true;
  late double expandedHeight = 0;

  void _scrollListener() {
    if (isShrink != lastStatus) {
      setState(() {
        lastStatus = isShrink;
      });
    }
  }

  bool get isShrink {
    return _scrollController.hasClients &&
        _scrollController.offset > (expandedHeight - (kToolbarHeight));
  }

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController()..addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    expandedHeight = MediaQuery.of(context).size.height * 0.4;

    return CustomScrollView(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      slivers: [
        _CustomAppBar(
          isShrink: isShrink,
          playlist: widget.playlist,
          expandedHeight: expandedHeight,
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            childCount: widget.playlist.songs.length,
            (context, index) {
              return ListTile(
                dense: true,
                minLeadingWidth: 20,
                horizontalTitleGap: 10,
                leading: Text(
                  '${index + 1}',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
                title: Text(
                  widget.playlist.songs[index].title,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
                subtitle: Text(
                  widget.playlist.songs[index].artist ?? '',
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Colors.white54,
                      ),
                ),
                trailing: Icon(
                  Icons.heart_broken_sharp,
                  color: Colors.red[300],
                ),
                onTap: () {
                  widget.playerProvider
                      .setPlayList(widget.playlist.songs, index);
                  if (widget.playerProvider.infoPlaylist.isNotEmpty) {
                    widget.playerProvider.audioPlayer.play();
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _CustomAppBar extends StatelessWidget {
  final bool isShrink;
  final double expandedHeight;
  final MyPlaylistModel playlist;

  const _CustomAppBar({
    required this.isShrink,
    required this.expandedHeight,
    required this.playlist,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SliverAppBar(
      backgroundColor: isShrink ? Colors.black : Colors.transparent,
      elevation: 0,
      expandedHeight: expandedHeight,
      floating: false,
      pinned: true,
      // leading: const Icon(Icons.arrow_back_ios),
      actions: const [Icon(Icons.dehaze_outlined)],
      flexibleSpace: LayoutBuilder(
        builder: (context, c) {
          final FlexibleSpaceBarSettings settings =
              context.dependOnInheritedWidgetOfExactType<
                  FlexibleSpaceBarSettings>() as FlexibleSpaceBarSettings;
          final deltaExtent = settings.maxExtent - settings.minExtent;
          final double t = (1.0 -
                  (settings.currentExtent - settings.minExtent) / deltaExtent)
              .clamp(0.0, 1.0);
          final fadeStart = math.max(0.0, 1.0 - kToolbarHeight / deltaExtent);
          final fadeStartText =
              math.max(0.0, 1.0 - expandedHeight / deltaExtent);
          const fadeEnd = 1.0;
          final opacity = 1.0 - Interval(fadeStart, fadeEnd).transform(t);
          final opacityText =
              1.0 - Interval(fadeStartText, fadeEnd).transform(t);

          return Stack(
            children: [
              Center(
                child: Opacity(
                  opacity: (1 - opacity),
                  child: SizedBox(
                    width: size.width * 0.7,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text('Playlist',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Color.fromRGBO(255, 255, 255, 0.5),
                            )),
                        AutoSizeText(
                          playlist.name,
                          textAlign: TextAlign.center,
                          minFontSize: 12,
                          maxLines: 1,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(
                          height: 7,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Opacity(
                opacity: opacity,
                child: Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    getImage(playlist.cover),
                    Opacity(
                      opacity: opacityText - 0.4 <= 0
                          ? (opacityText - 0.25 <= 0 ? 0 : opacityText - 0.1)
                          : opacityText,
                      child: Container(
                        width: size.width * 0.9,
                        padding: const EdgeInsets.only(left: 35),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AutoSizeText(
                              playlist.name,
                              textAlign: TextAlign.left,
                              minFontSize: 18,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 10.0,
                                      color: Colors.black54,
                                      offset: Offset(3.0, 3.0),
                                    ),
                                  ],
                                  color: Colors.white),
                            ),
                            AutoSizeText(
                              '${playlist.songs.length} canciones',
                              textAlign: TextAlign.left,
                              minFontSize: 14,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 20,
                                  color: Color.fromRGBO(255, 255, 255, 0.5)),
                            ),
                            const SizedBox(
                              height: kToolbarHeight - 15,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

Widget getImage(String? cover) {
  return SizedBox(
    width: double.infinity,
    child: ShaderMask(
      shaderCallback: (rect) {
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Colors.black.withOpacity(1.0),
            Colors.black.withOpacity(0.9),
            Colors.black.withOpacity(0.3),
            Colors.black.withOpacity(0.1),
            Colors.transparent,
          ],
          stops: const [0.0, 0.5, 0.8, 0.9, 1],
        ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
      },
      blendMode: BlendMode.dstIn,
      child: FadeInImage(
        placeholder: const AssetImage('assets/cover.jpg'),
        image: NetworkImage(cover ??
            'https://i0.wp.com/olumuse.org/wp-content/uploads/2020/09/unnamed.jpg?fit=512%2C512&ssl=1'),
        fit: BoxFit.cover,
      ),
    ),
  );
}
