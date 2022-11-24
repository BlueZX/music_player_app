import 'package:on_audio_query/on_audio_query.dart';

class MyPlaylistModel {
  final int id;
  final String name;
  final String? description;
  final String? cover;
  List<SongModel> songs;

  MyPlaylistModel({
    required this.id,
    required this.name,
    required this.songs,
    this.description,
    this.cover,
  });

  factory MyPlaylistModel.fromJson(Map<String, dynamic> json) =>
      MyPlaylistModel(
        id: json["id"],
        name: json["name"],
        cover: json["cover"],
        description: json["description"],
        songs: json["songs"] ?? [],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "cover": cover,
      };
}
