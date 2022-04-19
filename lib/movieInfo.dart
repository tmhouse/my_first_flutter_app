
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';
import 'mysecret.dart';

part "movieInfo.g.dart";

/**
 * ひとつの映画情報データホルダ.
 */
@JsonSerializable()
class MovieInfo {
  static const imageBaseUrl = "https://image.tmdb.org/t/p/w200";

  String _mergePath(String str) {
    return imageBaseUrl + "/" + str;
  }

  String getPoserPath() {
    return _mergePath(this.poster_path);
  }

  // json sampel = {
  //  adult: false,
  //  backdrop_path: /iQFcwSGbZXMkeyKrxbPnwnRo5fl.jpg,
  //  genre_ids: [28, 12, 878],
  //  id: 634649,
  //  original_language: en,
  //  original_title: Spider-Man: No Way Home,
  //  overview: 倒した敵の暴露により、世間から悪評を受けるスパイダーマン。自分の正体が知られていない世界に戻りたいと思うようになった彼は、友人のドクター・ストレンジに助けを求める。やがて魔法の力で、彼は違う世界線で2つの人生を同時に歩み始める,
  //  popularity: 6120.418,
  //  poster_path: /cFIph6JuKo53YaASQZhFC7qPJF7.jpg,
  //  release_date: 2021-12-15,
  //  title: スパイダーマン：ノー・ウェイ・ホーム,
  //  video: false,
  //  vote_average: 8.2,
  //  vote_count: 11355
  // }
  bool adult = false;
  String backdrop_path = "";
  List<num>? genre_ids; // [28, 12, 878],
  num id = 0; // 634649,
  String original_language = ""; // en,
  String original_title = ""; // Spider-Man: No Way Home,
  String overview = ""; //  倒した敵の暴露により、...
  num popularity = 0; // 6120.418,
  String poster_path = ""; // /cFIph6JuKo53YaASQZhFC7qPJF7.jpg,
  String release_date = ""; // 2021-12-15,
  String title = ""; // スパイダーマン：ノー・ウェイ・ホーム,
  bool video = false; // false,
  num vote_average = 0; // 8.2,
  num vote_count = 0; // 11355

  MovieInfo();

  factory MovieInfo.fromJson(Map<String, dynamic> json) => _$MovieInfoFromJson(json);

  Map<String, dynamic> toJson() => _$MovieInfoToJson(this);
}

/**
 * ひとつの映画の詳細情報のデータホルダ.
 */
@JsonSerializable()
class MovieDetail {
  bool adult = false;
  String backdrop_path = "";
  Map<String, dynamic>? belongs_to_collection;
  num budget = 0;
  List<Map<String, dynamic>>? genres;
  String homepage = "";
  num id = 0;
  String imdb_id = "";
  String original_language = "";
  String original_title = "";
  String overview = "";
  num popularity = 0;
  String poster_path = "";
  List<Map<String, dynamic>>? production_companies;
  List<Map<String, dynamic>>? production_countries;
  String release_date = "";
  num revenue = 0;
  num runtime = 0;
  List<Map<String, dynamic>>? spoken_languages;
  String status = "";
  String tagline = "";
  String title = "";
  bool video = false;
  num vote_average = 0;
  num vote_count = 0;

  MovieDetail();

  factory MovieDetail.fromJson(Map<String, dynamic> json) => _$MovieDetailFromJson(json);

  Map<String, dynamic> toJson() => _$MovieDetailToJson(this);
}


/**
 * 映画情報を取得するクラス.
 * https://www.themoviedb.org/
 */
class TheMovieDB {
  static const String _server = "https://api.themoviedb.org/3/";
  static const String _apiKey = "api_key=$tmdb_api_key";
  static const String _lang = "language=ja-JP";

  String _getMoviePopularPath() {
    const String p = _server + "movie/popular?" + _apiKey + "&" + _lang;
    return p;
  }
  String _getMovieDetailPath(String id) {
    return _server + "movie/" + id + "?" + _apiKey + "&" + _lang;
  }

  // singleton implements
  static TheMovieDB? _instance;
  factory TheMovieDB() {
    if( _instance == null ) {
      _instance = new TheMovieDB._internal();
    }
    return _instance!;
  }
  TheMovieDB._internal();

  /**
   * popularな映画のリストを取得開始する.
   */
  Future<List<MovieInfo>> startGettingPopularMovieList() async {
    Uri uri = Uri.parse(_getMoviePopularPath());
    final response = await http.get(uri);
    //log("http status=$response.statusCode,  response.body=" + response.body);
    String json = response.body;

    Map<String, dynamic> full_map = jsonDecode(json).cast<String, dynamic>();
    var result_list = full_map["results"] as List<dynamic>;
    var infoList = <MovieInfo>[];
    for( Map<String, dynamic> ent in result_list ) {
      var info = MovieInfo.fromJson(ent);
      //log("info=" + info.title);
      infoList.add(info);
    }
    return infoList;
  }

  /**
   * ひとつの映画の詳細情報の取得を開始する.
   */
  Future<MovieDetail> startGettingMovieDetail(String id) async {
    Uri uri = Uri.parse(_getMovieDetailPath(id));
    final response = await http.get(uri);
    Map<String, dynamic> full_map = jsonDecode(response.body).cast<String, dynamic>();
    log("detail full=" + full_map.toString());
    return MovieDetail.fromJson(full_map);
  }
}
