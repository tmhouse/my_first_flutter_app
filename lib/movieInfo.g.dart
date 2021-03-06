// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movieInfo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieInfo _$MovieInfoFromJson(Map<String, dynamic> json) => MovieInfo()
  ..poster_path = MovieDataHolder.convertToString(json['poster_path'])
  ..backdrop_path = MovieDataHolder.convertToString(json['backdrop_path'])
  ..adult = json['adult'] as bool
  ..genre_ids =
      (json['genre_ids'] as List<dynamic>?)?.map((e) => e as num).toList()
  ..id = MovieDataHolder.convertToString(json['id'])
  ..original_language =
      MovieDataHolder.convertToString(json['original_language'])
  ..original_title = MovieDataHolder.convertToString(json['original_title'])
  ..overview = MovieDataHolder.convertToString(json['overview'])
  ..popularity = json['popularity'] as num
  ..release_date = MovieDataHolder.convertToString(json['release_date'])
  ..title = MovieDataHolder.convertToString(json['title'])
  ..video = json['video'] as bool
  ..vote_average = json['vote_average'] as num
  ..vote_count = json['vote_count'] as num;

Map<String, dynamic> _$MovieInfoToJson(MovieInfo instance) => <String, dynamic>{
      'poster_path': instance.poster_path,
      'backdrop_path': instance.backdrop_path,
      'adult': instance.adult,
      'genre_ids': instance.genre_ids,
      'id': instance.id,
      'original_language': instance.original_language,
      'original_title': instance.original_title,
      'overview': instance.overview,
      'popularity': instance.popularity,
      'release_date': instance.release_date,
      'title': instance.title,
      'video': instance.video,
      'vote_average': instance.vote_average,
      'vote_count': instance.vote_count,
    };

MovieDetail _$MovieDetailFromJson(Map<String, dynamic> json) => MovieDetail()
  ..poster_path = MovieDataHolder.convertToString(json['poster_path'])
  ..backdrop_path = MovieDataHolder.convertToString(json['backdrop_path'])
  ..adult = json['adult'] as bool
  ..belongs_to_collection =
      json['belongs_to_collection'] as Map<String, dynamic>?
  ..budget = json['budget'] as num
  ..genres = (json['genres'] as List<dynamic>?)
      ?.map((e) => e as Map<String, dynamic>)
      .toList()
  ..homepage = json['homepage'] as String
  ..id = MovieDataHolder.convertToString(json['id'])
  ..imdb_id = MovieDataHolder.convertToString(json['imdb_id'])
  ..original_language =
      MovieDataHolder.convertToString(json['original_language'])
  ..original_title = MovieDataHolder.convertToString(json['original_title'])
  ..overview = MovieDataHolder.convertToString(json['overview'])
  ..popularity = json['popularity'] as num
  ..production_companies = (json['production_companies'] as List<dynamic>?)
      ?.map((e) => e as Map<String, dynamic>)
      .toList()
  ..production_countries = (json['production_countries'] as List<dynamic>?)
      ?.map((e) => e as Map<String, dynamic>)
      .toList()
  ..release_date = MovieDataHolder.convertToString(json['release_date'])
  ..revenue = json['revenue'] as num
  ..runtime = json['runtime'] as num
  ..spoken_languages = (json['spoken_languages'] as List<dynamic>?)
      ?.map((e) => e as Map<String, dynamic>)
      .toList()
  ..status = MovieDataHolder.convertToString(json['status'])
  ..tagline = MovieDataHolder.convertToString(json['tagline'])
  ..title = MovieDataHolder.convertToString(json['title'])
  ..video = json['video'] as bool
  ..vote_average = json['vote_average'] as num
  ..vote_count = json['vote_count'] as num;

Map<String, dynamic> _$MovieDetailToJson(MovieDetail instance) =>
    <String, dynamic>{
      'poster_path': instance.poster_path,
      'backdrop_path': instance.backdrop_path,
      'adult': instance.adult,
      'belongs_to_collection': instance.belongs_to_collection,
      'budget': instance.budget,
      'genres': instance.genres,
      'homepage': instance.homepage,
      'id': instance.id,
      'imdb_id': instance.imdb_id,
      'original_language': instance.original_language,
      'original_title': instance.original_title,
      'overview': instance.overview,
      'popularity': instance.popularity,
      'production_companies': instance.production_companies,
      'production_countries': instance.production_countries,
      'release_date': instance.release_date,
      'revenue': instance.revenue,
      'runtime': instance.runtime,
      'spoken_languages': instance.spoken_languages,
      'status': instance.status,
      'tagline': instance.tagline,
      'title': instance.title,
      'video': instance.video,
      'vote_average': instance.vote_average,
      'vote_count': instance.vote_count,
    };
