import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:music_player_app/providers/db_provider.dart';
import 'package:music_player_app/providers/playlist_provider.dart';
import 'package:provider/provider.dart';

class PlaylistSlider extends StatelessWidget {
  final String? title;

  const PlaylistSlider({
    Key? key,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final playlistProvider = Provider.of<PlaylistProvider>(context);
    return SizedBox(
      width: double.infinity,
      height: 280,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: AutoSizeText(
              title ?? 'Listas de reproduccion',
              style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: playlistProvider.playlists.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, int index) => _PlaylistContainer(
                playlist: playlistProvider.playlists[index],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlaylistContainer extends StatelessWidget {
  final MyPlaylistModel playlist;

  const _PlaylistContainer({
    Key? key,
    required this.playlist,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      height: 175,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => Navigator.pushNamed(
              context,
              'playlist',
              arguments: playlist,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage(
                placeholder: const AssetImage('assets/cover.jpg'),
                image: NetworkImage(
                    playlist.cover ?? 'https://via.placeholder.com/150x300'),
                width: 160,
                height: 175,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(
            height: 7,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: AutoSizeText(
              playlist.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Text(
              '${playlist.songs.length} canciones',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Colors.white54,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
