import 'package:flutter/material.dart';
import 'package:netflix/common/utils.dart';
import 'package:netflix/models/now_playing_movies.dart';
import 'package:netflix/models/top_rated_series.dart';
import 'package:netflix/models/upcoming_movies.dart';
import 'package:netflix/screens/search.dart';
import 'package:netflix/services/api_services.dart';
import 'package:netflix/widgets/custom_carousel.dart';
import 'package:netflix/widgets/now_playing_movie_card.dart';
import 'package:netflix/widgets/upcoming_movie_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<UpcomingMovies> upcomingMovies;
  late Future<TopRatedSeries> topRatedSeries;
  late Future<NowPlayingMovies> nowPlayingMovies;

  ApiServices apiServices = ApiServices();

  @override
  void initState() {
    topRatedSeries = apiServices.getTopRatedSeries();
    upcomingMovies = apiServices.getUpcomingMovies();
    nowPlayingMovies = apiServices.getNowPlayingMovies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: customBackground,
          title: Image.asset(
            'assets/logo.png',
            height: 55,
            width: 120,
          ),
          actions: [
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const Search()));
              },
              child: const Icon(
                Icons.search,
                color: Colors.white,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 15.0,
                right: 20,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(7),
                child: Image.asset(
                  'assets/avatar.jpeg',
                  height: 27,
                  width: 27,
                ),
              ),
            )
          ],
        ),
        body: ListView(
          children: [
            FutureBuilder(
                future: upcomingMovies,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.all(50.0),
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      ),
                    );
                  }
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        FutureBuilder(
                            future: topRatedSeries,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Padding(
                                  padding: EdgeInsets.all(50.0),
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  ),
                                );
                              }
                              return Column(
                                children: [
                                  CustomCarousel(series: snapshot.data!),
                                ],
                              );
                            }),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: SizedBox(
                            height: 220,
                            child: NowPlayingMovieCard(
                                movies: nowPlayingMovies,
                                header: 'Now Playing'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: SizedBox(
                            height: 220,
                            child: UpcomingMovieCard(
                                movies: upcomingMovies,
                                header: 'Upcoming Movies'),
                          ),
                        ),
                      ],
                    ),
                  );
                })
          ],
        ));
  }
}
