import 'dart:convert';
import 'dart:developer';

import 'package:netflix/common/utils.dart';
import 'package:netflix/models/movie_details.dart';
import 'package:netflix/models/movie_recommentations.dart';
import 'package:netflix/models/now_playing_movies.dart';
import 'package:netflix/models/popular_movies.dart';
import 'package:netflix/models/searched_movies.dart';
import 'package:netflix/models/top_rated_series.dart';
import 'package:netflix/models/upcoming_movies.dart';
import 'package:http/http.dart' as http;

const baseUrl = 'https://api.themoviedb.org/3/';

var key = '?api_key=$apiKey';
late String endPoint;

class ApiServices {
  Future<UpcomingMovies> getUpcomingMovies() async {
    endPoint = 'movie/upcoming';
    String url = '$baseUrl$endPoint$key';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      log('success');
      return UpcomingMovies.fromJson(jsonDecode(response.body));
    }
    throw Exception('failed to load upcoming movies');
  }

  Future<NowPlayingMovies> getNowPlayingMovies() async {
    endPoint = 'movie/now_playing';
    String url = '$baseUrl$endPoint$key';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      log('success');
      return NowPlayingMovies.fromJson(jsonDecode(response.body));
    }
    throw Exception('failed to load upcoming movies');
  }

  Future<TopRatedSeries> getTopRatedSeries() async {
    endPoint = 'tv/top_rated';
    String url = '$baseUrl$endPoint$key';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      log('success');
      return TopRatedSeries.fromJson(jsonDecode(response.body));
    }
    throw Exception('failed to load top rated series');
  }

  Future<SearchedMovies> getSearchedovie(String searchKeyWord) async {
    endPoint = 'search/movie?query=$searchKeyWord';
    final url = '$baseUrl$endPoint';
    print(url);
    final response = await http.get(Uri.parse(url), headers: {
      'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI3ZWYyZWU1YzJhNjM4NzZmMDU1OWViYjM5YTc3NDJjYyIsIm5iZiI6MTczNDk0NjU3OC42MDgsInN1YiI6IjY3NjkyZjEyODVkOTJmYTZhZDVjZTU2YiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.tQbiNe3gL_FKyPxUDm9yTgptyUYe71_Y-uvbuJiTxeo'
    });
    log(response.statusCode.toString());

    if (response.statusCode == 200) {
      log('success');
      return SearchedMovies.fromJson(jsonDecode(response.body));
    }
    throw Exception('failed to load searched movie');
  }

  Future<PopularMovies> getPopularMovies() async {
    endPoint = 'movie/popular';
    final url = '$baseUrl$endPoint$key';
    print(url);
    final response = await http.get(Uri.parse(url));
    log(response.statusCode.toString());

    if (response.statusCode == 200) {
      log('success');
      return PopularMovies.fromJson(jsonDecode(response.body));
    }
    throw Exception('failed to load searched movie');
  }

  Future<MovieDetails> getMovieDetails(int id) async {
    endPoint = 'movie/$id';
    final url = '$baseUrl$endPoint$key';
    print(url);
    final response = await http.get(Uri.parse(url));
    log(response.statusCode.toString());

    if (response.statusCode == 200) {
      log('success');
      return MovieDetails.fromJson(jsonDecode(response.body));
    }
    throw Exception('failed to load searched movie');
  }

  Future<MovieRecommentations> getMovieRecommentations(int movieId) async {
    endPoint = 'movie/$movieId/recommentations';
    final url = '$baseUrl$endPoint$key';
    print(url);
    final response = await http.get(Uri.parse(url));
    log(response.statusCode.toString());

    if (response.statusCode == 200) {
      log('success');
      return MovieRecommentations.fromJson(jsonDecode(response.body));
    }
    throw Exception('failed to load searched movie');
  }
}
