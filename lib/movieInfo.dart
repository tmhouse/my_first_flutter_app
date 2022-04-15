
import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';
import 'mysecret.dart';

part "movieInfo.g.dart";

/**
 * ひとつの映画情報データホルダ.
 */
class MovieInfo {
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

  final bool adult;
  final String backdrop_path;
  final List<dynamic> genre_ids; // [28, 12, 878],
  final String id; // 634649,
  final String original_language; // en,
  final String original_title; // Spider-Man: No Way Home,
  final String overview; //  倒した敵の暴露により、...
  final num popularity; // 6120.418,
  final String poster_path; // /cFIph6JuKo53YaASQZhFC7qPJF7.jpg,
  final String release_date; // 2021-12-15,
  final String title; // スパイダーマン：ノー・ウェイ・ホーム,
  final bool video; // false,
  final num vote_average; // 8.2,
  final num vote_count; // 11355

  /****
  MovieInfo(this.adult,
      this.backdrop_path,
      this.genre_ids,
      this.id,
      this.original_language,
      this.original_title,
      this.overview,
      this.popularity,
      this.poster_path,
      this.release_date,
      this.title,
      this.video,
      this.vote_average,
      this.vote_count);
      ****/

  // map to User
  MovieInfo.fromJson(Map<String, dynamic> json)
      : this.adult = json['adult'],
        this.backdrop_path = _posterImageBaseUrl + json['backdrop_path'],
        this.genre_ids = json['genre_ids'],
        this.id = json['id'].toString(),
        this.original_language = json['original_language'],
        this.original_title = json['original_title'],
        this.overview = json['overview'],
        this.popularity = json['popularity'],
        this.poster_path = _posterImageBaseUrl + json['poster_path'],
        this.release_date = json['release_date'],
        this.title = json['title'],
        this.video = json['video'],
        this.vote_average = json['vote_average'],
        this.vote_count = json['vote_count']
  ;

  // map to json
  /***
  Map<String, dynamic> toJson() {
    //'name': name,
    //'hobby': hobby,
    throw UnimplementedError("implement please");
  }
      ***/

  static const _posterImageBaseUrl = "https://image.tmdb.org/t/p/w200";
}

/**
 * ひとつの映画の詳細情報のデータホルダ.
 */
@JsonSerializable()
class MovieDetail {
  bool? adult;
  String? backdrop_path;
  String? belongs_to_collection;
  num? budget;
  List<dynamic>? genres;
  String? homepage;
  num? id;
  String? imdb_id;
  String? original_language;
  String? original_title;
  String? overview;
  num? popularity;
  String? poster_path;
  List<dynamic>? production_companies;
  List<dynamic>? production_countries;
  String? release_date;
  num? revenue;
  num? runtime;
  List<dynamic>? spoken_languages;
  String? status;
  String? tagline;
  String? title;
  bool? video;
  num? vote_average;
  num? vote_count;

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
      log("info=" + info.title);
      infoList.add(info);
    }

    result_list.forEach((element) {
      infoList.add(MovieInfo.fromJson(element));
    });
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
