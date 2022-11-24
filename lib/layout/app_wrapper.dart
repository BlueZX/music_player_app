import 'dart:io';

import 'package:flutter/material.dart';
import 'package:music_player_app/providers/db_provider.dart';
import 'package:music_player_app/providers/playlist_provider.dart';
import 'package:provider/provider.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:music_player_app/layout/bottom_navbar.dart';
import 'package:music_player_app/providers/bottom_navegationbar_provider.dart';
import 'package:music_player_app/providers/player_provider.dart';
import 'package:music_player_app/widgets/custom_page_route.dart';
import 'package:music_player_app/widgets/play_bar_control.dart';
import 'package:music_player_app/screens/screens.dart';

class AppWrapper extends StatefulWidget {
  final Widget? content;
  final Color? backgroundColor;
  final PreferredSizeWidget? appBar;
  final bool? withBottomNavbar;

  const AppWrapper(
      {Key? key,
      this.content,
      this.backgroundColor,
      this.appBar,
      this.withBottomNavbar = false})
      : super(key: key);

  @override
  State<AppWrapper> createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> {
  final OnAudioQuery audioQuery = OnAudioQuery();

  requestPermission() async {
    if (Platform.isAndroid) {
      bool permissionStatus = await audioQuery.permissionsStatus();
      if (!permissionStatus) {
        await audioQuery.permissionsRequest();
      }
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    requestPermission();
  }

  dynamic getCurrentTab(int index, PlayerProvider playerProvider,
      PlaylistProvider playlistProvider) {
    switch (index) {
      // case 2:
      //   return const PlaylistScreen();
      case 0:
        playlistProvider.loadPlaylists();
        return Navigator(
          onGenerateRoute: (settings) {
            Widget page = HomeContentScreen(
              audioQuery: audioQuery,
              playerProvider: playerProvider,
            );
            if (settings.name == 'playlist' && settings.arguments != null) {
              page = PlaylistScreen(
                playlist: settings.arguments as MyPlaylistModel,
                playerProvider: playerProvider,
                // playlistProvider = playlistProvider,
              );
            }
            return MaterialPageRoute(builder: (_) => page);
          },
        );
      case 1:
      default:
        return ListSongsScreen(
          playerProvider: playerProvider,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final navigationBarProvider =
        Provider.of<BottomNavigationBarProvider>(context);
    final playerProvider = Provider.of<PlayerProvider>(context);
    final playlistProvider =
        Provider.of<PlaylistProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: widget.backgroundColor ?? Colors.transparent,
      appBar: widget.appBar,
      bottomNavigationBar: widget.withBottomNavbar!
          ? BottomNavBar(
              currentIndex: navigationBarProvider.currentIndex,
              onTap: (index) {
                navigationBarProvider.currentIndex = index;
              },
            )
          : null,
      body: widget.withBottomNavbar!
          ? StreamBuilder<SongModel?>(
              stream: playerProvider.currentSongStream.stream,
              builder: (context, currentSongStream) {
                final indexData = currentSongStream.data;
                return Stack(
                  children: [
                    widget.content ??
                        getCurrentTab(
                          navigationBarProvider.currentIndex,
                          playerProvider,
                          playlistProvider,
                        ),
                    if (playerProvider.infoPlaylist.isNotEmpty &&
                        indexData != null)
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: GestureDetector(
                          onTap: () {
                            if (playerProvider.infoPlaylist.isNotEmpty) {
                              Navigator.of(context).push(
                                CustomPageRoute(
                                    child: PlayerScreen(
                                        playerProvider: playerProvider)),
                              );
                            }
                          },
                          onHorizontalDragEnd: (details) {
                            print('current detail: ${details.primaryVelocity}');
                            if (details.primaryVelocity! < -500) {
                              playerProvider
                                  .setId(playerProvider.audioPlayer.nextIndex);
                              playerProvider.audioPlayer.seekToNext();
                            } else if (details.primaryVelocity! > 500) {
                              playerProvider.setId(
                                  playerProvider.audioPlayer.previousIndex);
                              playerProvider.audioPlayer.seekToPrevious();
                            }
                          },
                          child: PlayBarControl(
                              playerProvider: playerProvider,
                              songData: indexData),
                        ),
                      ),
                  ],
                );
              },
            )
          : widget.content,
    );
  }
}
