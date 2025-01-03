// ignore_for_file: constant_identifier_names

import 'dart:convert';

class MovieRecommendations {
  final int page;
  final List<Result> results;
  final int totalPages;
  final int totalResults;

  MovieRecommendations({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory MovieRecommendations.fromRawJson(String str) =>
      MovieRecommendations.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MovieRecommendations.fromJson(Map<String, dynamic> json) =>
      MovieRecommendations(
        page: json["page"] ?? 0,
        results: (json["results"] as List<dynamic>?)
                ?.map((x) => Result.fromJson(x))
                .toList() ??
            [],
        totalPages: json["total_pages"] ?? 0,
        totalResults: json["total_results"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "page": page,
        "results": results.map((x) => x.toJson()).toList(),
        "total_pages": totalPages,
        "total_results": totalResults,
      };
}

class Result {
  final String? backdropPath;
  final int id;
  final String title;
  final String originalTitle;
  final String overview;
  final String? posterPath;
  final MediaType? mediaType;
  final bool adult;
  final OriginalLanguage? originalLanguage;
  final List<int> genreIds;
  final double popularity;
  final DateTime? releaseDate;
  final bool video;
  final double voteAverage;
  final int voteCount;

  Result({
    this.backdropPath,
    required this.id,
    required this.title,
    required this.originalTitle,
    required this.overview,
    this.posterPath,
    this.mediaType,
    required this.adult,
    this.originalLanguage,
    required this.genreIds,
    required this.popularity,
    this.releaseDate,
    required this.video,
    required this.voteAverage,
    required this.voteCount,
  });

  factory Result.fromRawJson(String str) => Result.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        backdropPath: json["backdrop_path"] as String?,
        id: json["id"] ?? 0,
        title: json["title"] ?? "Untitled",
        originalTitle: json["original_title"] ?? "Untitled",
        overview: json["overview"] ?? "No overview available",
        posterPath: json["poster_path"] as String?,
        mediaType: mediaTypeValues.map[json["media_type"]],
        adult: json["adult"] ?? false,
        originalLanguage: originalLanguageValues.map[json["original_language"]],
        genreIds: (json["genre_ids"] as List<dynamic>?)
                ?.map((x) => x as int)
                .toList() ??
            [],
        popularity: (json["popularity"] as num?)?.toDouble() ?? 0.0,
        releaseDate: json["release_date"] != null
            ? DateTime.tryParse(json["release_date"])
            : null,
        video: json["video"] ?? false,
        voteAverage: (json["vote_average"] as num?)?.toDouble() ?? 0.0,
        voteCount: json["vote_count"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "backdrop_path": backdropPath,
        "id": id,
        "title": title,
        "original_title": originalTitle,
        "overview": overview,
        "poster_path": posterPath,
        "media_type": mediaTypeValues.reverse[mediaType],
        "adult": adult,
        "original_language": originalLanguageValues.reverse[originalLanguage],
        "genre_ids": genreIds,
        "popularity": popularity,
        "release_date": releaseDate?.toIso8601String(),
        "video": video,
        "vote_average": voteAverage,
        "vote_count": voteCount,
      };
}

enum MediaType { MOVIE }

final mediaTypeValues = EnumValues({"movie": MediaType.MOVIE});

enum OriginalLanguage { EN, IT, PT }

final originalLanguageValues = EnumValues({
  "en": OriginalLanguage.EN,
  "it": OriginalLanguage.IT,
  "pt": OriginalLanguage.PT,
});

class EnumValues<T> {
  final Map<String, T> map;
  late final Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse => reverseMap = map.map((k, v) => MapEntry(v, k));
}
