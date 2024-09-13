import 'dart:convert';

MusicModel musicModelFromJson(String str) => MusicModel.fromJson(json.decode(str));

String musicModelToJson(MusicModel data) => json.encode(data.toJson());

class MusicModel {
  final String? singerName;
  final String? songCategory;
  final String? songName;
  final String? songUrl;
  final String? themePath;

  MusicModel({
    this.singerName,
    this.songCategory,
    this.songName,
    this.songUrl,
    this.themePath,
  });

  factory MusicModel.fromJson(Map<String, dynamic> json) => MusicModel(
        singerName: json["singerName"],
        songName: json["songName"],
        songUrl: json["songUrl"],
        themePath: json["themePath"],
        songCategory: json["songCategory"],
      );

  Map<String, dynamic> toJson() => {
        "singerName": singerName,
        "songName": songName,
        "songUrl": songUrl,
        "themePath": themePath,
        "songCategory": songCategory, // Add new field to JSON
      };
}
