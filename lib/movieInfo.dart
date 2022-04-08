
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'mysecret.dart';

/**
 * 映画情報を取得するクラス.
 * https://www.themoviedb.org/
 */
class TheMovieDB {
  static const String _server = "https://api.themoviedb.org/3/";
  static const String _apiKey = "api_key=$tmdb_api_key";
  static const String _lang = "language=ja-JP";
  static const String _get_movie_popular = _server + "movie/popular?" + _apiKey + "&" + _lang;

  // singleton implements
  static TheMovieDB? _instance;
  factory TheMovieDB() {
    if( _instance == null ) {
      _instance = new TheMovieDB._internal();
    }
    return _instance!;
  }
  TheMovieDB._internal();

  Future<String> getMoviePopular() async {
    Uri uri = Uri.parse(_get_movie_popular);
    final response = await http.get(uri);
    //print("http status=$response.statusCode,  response.body=" + response.body);
    return response.body;
  }

}
