import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlayerProvider extends ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();

  late final StreamSubscription<int?> _currentIndexStream;

  int _id = 0;
  List<AudioSource> _songPlaylist = [];
  List<SongModel> _infoPlaylist = [];
  StreamController<SongModel?> currentSongStream =
      StreamController<SongModel?>.broadcast();

  AudioPlayer get audioPlayer => _audioPlayer;
  int get id => _id;
  List<AudioSource> get songPlaylist => _songPlaylist;
  List<SongModel> get infoPlaylist => _infoPlaylist;

  void resetCurrentSongStream() {
    currentSongStream.close();
    currentSongStream = StreamController<SongModel?>();
  }

  void setId(int? id) {
    _id = id ?? _id;
    print('set index id: $_id');
    // notifyListeners();
  }

  void setCurrentSong(int index) {
    if (_infoPlaylist.isNotEmpty) {
      print('new song: ${_infoPlaylist[index].title}');
      currentSongStream.sink.add(_infoPlaylist[index]);
    }
  }

  void addSongToPlaylist(SongModel song) {
    _songPlaylist.add(
      AudioSource.uri(
        Uri.parse(song.uri!),
        tag: MediaItem(
          id: '${song.id}',
          album: "${song.album}",
          title: song.title,
          artUri: Uri.parse(song.albumId.toString()),
        ),
      ),
    );
    _infoPlaylist = [..._infoPlaylist, song];

    _setPlayListToAudioPlayer(_id);

    print('set new cancion: ${song.title}');
  }

  void setPlayList(List<SongModel> playlist, [int? newId]) {
    if (!listEquals(_infoPlaylist, playlist)) {
      _songPlaylist = [];
      _infoPlaylist = playlist;

      for (var song in playlist) {
        print('${song.title}');
        _songPlaylist.add(
          AudioSource.uri(
            Uri.parse(song.uri!),
            tag: MediaItem(
              id: '${song.id}',
              album: "${song.album}",
              title: song.title,
              artUri: Uri.parse(song.id.toString()),
            ),
          ),
        );
      }
    }

    _setPlayListToAudioPlayer(newId);
  }

  void _setPlayListToAudioPlayer([int? newId]) {
    if (songPlaylist.isNotEmpty &&
        (_id != newId || audioPlayer.audioSource == null)) {
      if (newId != null) setId(newId);

      audioPlayer.setAudioSource(
        ConcatenatingAudioSource(children: songPlaylist),
        initialIndex: newId ?? 0,
      );
    }
  }

  PlayerProvider() {
    _currentIndexStream = _audioPlayer.currentIndexStream.listen(
      (event) {
        if (event != null && id == event) {
          setCurrentSong(event);
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    currentSongStream.close();
    _currentIndexStream.cancel();
    audioPlayer.dispose();
  }
}
