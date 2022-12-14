import 'dart:io';

import 'package:flutter/material.dart';
import 'package:music_player_app/providers/db_provider.dart';
import 'package:music_player_app/providers/playlist_provider.dart';
import 'package:provider/provider.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:music_player_app/layout/bottom_navbar.dart';
import 'package:music_player_app/providers/bottom_navegationbar_provider.dart';
import 'package:music_player_app/providers/player_provider.dart';
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
  requestPermission() async {
    if (Platform.isAndroid) {
      final playlistProvider =
          Provider.of<PlaylistProvider>(context, listen: false);
      bool permissionStatus =
          await playlistProvider.audioQuery.permissionsStatus();
      if (!permissionStatus) {
        await playlistProvider.audioQuery.permissionsRequest();
      }
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    requestPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.backgroundColor ?? Colors.transparent,
      appBar: widget.appBar,
      bottomNavigationBar:
          widget.withBottomNavbar! ? const BottomNavBar() : null,
      body: widget.withBottomNavbar!
          ? _TabScreen(content: widget.content)
          : widget.content,
    );
  }
}

class _TabScreen extends StatelessWidget {
  final Widget? content;

  const _TabScreen({
    Key? key,
    this.content,
  }) : super(key: key);

  Widget getCurrentTab(BuildContext context, int index) {
    switch (index) {
      // case 2:
      //   return const PlaylistScreen();
      case 0:
        final playlistProvider =
            Provider.of<PlaylistProvider>(context, listen: false);

        playlistProvider.loadPlaylists();

        return Navigator(
          onGenerateRoute: (settings) {
            Widget page = const HomeContentScreen();
            if (settings.name == 'playlist' && settings.arguments != null) {
              page = PlaylistScreen(
                playlist: settings.arguments as MyPlaylistModel,
              );
            }
            return MaterialPageRoute(builder: (_) => page);
          },
        );
      case 1:
      default:
        return const ListSongsScreen();
    }
  }

  Future<T?> handlePlayer<T>(BuildContext context) {
    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      clipBehavior: Clip.antiAlias,
      context: context,
      enableDrag: true,
      isDismissible: true,
      isScrollControlled: true,
      builder: (modalContext) => const PlayerScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final navigationBarProvider =
        Provider.of<BottomNavigationBarProvider>(context);
    final playerProvider = Provider.of<PlayerProvider>(context);

    return StreamBuilder<SongModel?>(
      stream: playerProvider.currentSongStream.stream,
      builder: (context, currentSongStream) {
        final indexData = currentSongStream.data;
        return Stack(
          children: [
            content ??
                getCurrentTab(context, navigationBarProvider.currentIndex),
            if (playerProvider.infoPlaylist.isNotEmpty && indexData != null)
              Align(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  onTap: () {
                    if (playerProvider.infoPlaylist.isNotEmpty) {
                      handlePlayer(context);
                    }
                  },
                  onVerticalDragStart: (details) => handlePlayer(context),
                  onHorizontalDragEnd: (details) {
                    print('current detail: ${details.primaryVelocity}');
                    if (details.primaryVelocity! < -500) {
                      playerProvider
                          .setId(playerProvider.audioPlayer.nextIndex);
                      playerProvider.audioPlayer.seekToNext();
                    } else if (details.primaryVelocity! > 500) {
                      playerProvider
                          .setId(playerProvider.audioPlayer.previousIndex);
                      playerProvider.audioPlayer.seekToPrevious();
                    }
                  },
                  child: PlayBarControl(songData: indexData),
                ),
              ),
          ],
        );
      },
    );
  }
}
