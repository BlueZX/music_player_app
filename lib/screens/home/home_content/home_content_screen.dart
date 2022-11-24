import 'package:flutter/material.dart';
import 'package:music_player_app/widgets/widgets.dart';
import 'package:on_audio_query/on_audio_query.dart';

class HomeContentScreen extends StatelessWidget {
  final OnAudioQuery audioQuery;

  const HomeContentScreen({
    Key? key,
    required this.audioQuery,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            ListSongs(audioQuery: audioQuery),
            const SizedBox(
              height: 60,
            ),
          ],
        ),
      ),
    );
  }
}
