import 'package:on_audio_query/on_audio_query.dart';

class MySongModel extends SongModel {
  final int playlistId;
  MySongModel(super.info, [this.playlistId = 1]);

  // factory MySongModel.fromJson(Map<String, dynamic> json) => SongModel(
  //       id: json["id"],
  //       name: json["name"],
  //       cover: json["cover"],
  //       description: json["description"],
  //     );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "artist": artist,
        "album": album,
        "albumId": albumId,
        "uri": uri,
        "playlistId": playlistId,
      };
}
