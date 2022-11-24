import 'package:flutter/material.dart';
import 'package:music_player_app/search/search_delegate.dart';
import 'package:music_player_app/widgets/widgets.dart';

class HomeContentScreen extends StatelessWidget {
  const HomeContentScreen({
    Key? key,
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
              icon: const Icon(
                Icons.search_outlined,
              ),
              onPressed: () {
                showSearch(context: context, delegate: SongSearchDelegate());
              },
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: const [
            PlaylistSlider(),
            ListSongs(),
            SizedBox(
              height: 60,
            ),
          ],
        ),
      ),
    );
  }
}
