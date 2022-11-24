import 'dart:io';

// ignore: depend_on_referenced_packages
import 'package:on_audio_query/on_audio_query.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'package:music_player_app/models/my_song_model.dart';
import 'package:music_player_app/models/playlist_model.dart';
export 'package:music_player_app/models/playlist_model.dart';
export 'package:music_player_app/models/my_song_model.dart';

class DBProvider {
  static Database? _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await initDB();

    return _database;
  }

  Future<Database> initDB() async {
    // Path de donde se almacenara la db
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'PlaylistsDB4.db');
    print('path: $path');

    //crear DB
    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE Playlists(
            id INTEGER PRIMARY KEY,
            name TEXT,
            cover TEXT,
            description TEXT
          );
        ''');
        await db.execute('''
          CREATE TABLE Songs(
            id INTEGER PRIMARY KEY,
            title TEXT,
            artist TEXT,
            album TEXT,
            albumId TEXT,
            uri TEXT,
            playlistId INTEGER
          );
        ''');
      },
    );
  }

  Future<int> newPlaylistRaw(MyPlaylistModel newPlaylist) async {
    final id = newPlaylist.id;
    final name = newPlaylist.name;
    final description = newPlaylist.description;
    final cover = newPlaylist.cover;

    //Verificar la db
    final db = await database;

    final res = await db!.rawInsert('''
      INSERT INTO Playlists(id, name, description, cover)
      VALUES( $id, $name, $description, $cover)
    ''');

    return res;
  }

  Future<int> newPlaylist(MyPlaylistModel newPlaylist) async {
    //Verificar la db
    final db = await database;
    // res es el id
    final res = await db!.insert('Playlists', newPlaylist.toJson());
    print('id playlist: $res');
    return res;
  }

  Future<int> newSong(MySongModel newSong) async {
    //Verificar la db
    final db = await database;
    // res es el id
    final res = await db!.insert('Songs', newSong.toJson());
    print('id cancion: $res');
    return res;
  }

  Future<int> deleteSong(int playlistId, [String? uri]) async {
    final db = await database;

    final res = await db!.delete('Songs',
        where: 'playlistId= ? AND uri= ?', whereArgs: [playlistId, uri]);
    print('cancion eliminada id: $res');
    return res;
  }

  Future<List<MyPlaylistModel>?> getPlaylists() async {
    final db = await database;

    if (db != null) {
      final res = await db.query('Playlists');

      return res.isNotEmpty
          ? res.map((p) => MyPlaylistModel.fromJson(p)).toList()
          : [];
    }

    return null;
  }

  Future<List<SongModel>?> getSongs(int playlistId) async {
    //Verificar la db
    final db = await database;

    if (db != null) {
      final res = await db
          .query('Songs', where: 'playlistId = ?', whereArgs: [playlistId]);

      print('res: $res');

      return res.isNotEmpty
          ? res
              .map(
                (s) => SongModel(
                  {
                    '_id': s["id"],
                    'album': s["album"],
                    'title': s["title"],
                    "artist": s["artist"],
                    'albumId': s["albumId"],
                    '_uri': s["uri"],
                  },
                ),
              )
              .toList()
          : [];
    }

    return null;
  }

  Future<List<MyPlaylistModel>?> getPlaylistsWithSongs() async {
    final List<MyPlaylistModel>? playlist = await getPlaylists();
    Map<int, List<SongModel>?> songs = {};

    if (playlist != null) {
      for (var p in playlist) {
        songs.addAll({p.id: await getSongs(p.id)});
      }
      return playlist.isNotEmpty
          ? playlist
              .map(
                (p) => MyPlaylistModel(
                    id: p.id,
                    name: p.name,
                    cover: p.cover,
                    description: p.description,
                    songs: songs[p.id] ?? []),
              )
              .toList()
          : [];
    }

    return null;
  }
}
