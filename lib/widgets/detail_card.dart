import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class DetailCard extends StatelessWidget {
  const DetailCard({
    Key? key,
    required this.song,
    required this.size,
  }) : super(key: key);

  final Size size;
  final SongModel song;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 5,
      child: Container(
        width: size.width * 0.9,
        height: size.height * 0.45,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(50),
            bottomRight: Radius.circular(50),
          ),
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromRGBO(33, 33, 33, 1),
                Color.fromRGBO(45, 45, 45, 1),
              ]),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              spreadRadius: 25,
              blurRadius: 50,
              offset: Offset(0, 80),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: size.width * 0.6,
              height: size.width * 0.6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: const Color.fromRGBO(20, 20, 20, 1),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    spreadRadius: 10,
                    blurRadius: 25,
                    offset: Offset(0, 20),
                  ),
                ],
              ),
              child: _ArtWorkWidget(
                size: size.width * 0.6,
                song: song,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                song.title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              song.artist ?? 'Artista desconocido',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: Color.fromRGBO(255, 255, 255, 0.5),
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}

class _ArtWorkWidget extends StatelessWidget {
  final SongModel song;
  final double size;
  const _ArtWorkWidget({
    Key? key,
    required this.song,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return QueryArtworkWidget(
      id: song.artistId ?? 0,
      type: ArtworkType.AUDIO,
      artworkHeight: size,
      artworkWidth: size,
      artworkFit: BoxFit.cover,
      nullArtworkWidget: Icon(
        Icons.music_note,
        color: Colors.white70,
        size: size - 10,
      ),
    );
  }
}
