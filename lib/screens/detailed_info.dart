import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:netflix/common/utils.dart';
import 'package:netflix/models/movie_details.dart';
import 'package:netflix/models/movie_recommendations.dart';
import 'package:netflix/services/api_services.dart';

class DetailedInfo extends StatefulWidget {
  final int movieId;
  const DetailedInfo({super.key, required this.movieId});

  @override
  State<DetailedInfo> createState() => _DetailedInfoState();
}

class _DetailedInfoState extends State<DetailedInfo> {
  ApiServices apiServices = ApiServices();
  late Future<MovieDetails> movieDetails;
  late Future<MovieRecommendations?> movieRecommentations;

  @override
  void initState() {
    fetchDetails();
    super.initState();
  }

  fetchDetails() {
    movieDetails = apiServices.getMovieDetails(widget.movieId);
    movieRecommentations = apiServices.getMovieRecommentations(widget.movieId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print(widget.movieId);
    return Scaffold(
      body: SingleChildScrollView(
        child: FutureBuilder(
            future: movieDetails,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final data = snapshot.data;
                // print(data!.id);
                String genre =
                    data!.genres.map((genre) => genre.name).join(', ');
                return Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                            height: MediaQuery.of(context).size.height * 0.6,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(
                                  '$imageUrl${data.posterPath}',
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: SafeArea(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      icon: const Icon(
                                        Icons.arrow_back_ios,
                                      )),
                                ],
                              ),
                            ))
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 10.0,
                        right: 10,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            data.title,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              Text(
                                data.releaseDate.year.toString(),
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 17,
                                ),
                              ),
                              const SizedBox(
                                width: 30,
                              ),
                              Text(
                                genre,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 17,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Text(
                            data.overview,
                            maxLines: 6,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    FutureBuilder(
                        future: movieRecommentations,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final recommentations = snapshot.data;

                            return recommentations!.results.isEmpty
                                ? const SizedBox()
                                : Padding(
                                    padding: const EdgeInsets.only(
                                      left: 10.0,
                                      right: 10,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'More like this :',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        GridView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount:
                                                recommentations.results.length,
                                            gridDelegate:
                                                const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 3,
                                              mainAxisSpacing: 15,
                                              crossAxisSpacing: 10,
                                              childAspectRatio: 1.5 / 2,
                                            ),
                                            itemBuilder: (context, index) {
                                              return recommentations
                                                          .results[index]
                                                          .posterPath ==
                                                      null
                                                  ? Image.asset(
                                                      'assets/netflix.png',
                                                      height: 170,
                                                    )
                                                  : InkWell(
                                                      onTap: () {
                                                        Navigator.of(context).push(
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (cntxt) {
                                                          return DetailedInfo(
                                                              movieId:
                                                                  recommentations
                                                                      .results[
                                                                          index]
                                                                      .id);
                                                        }));
                                                      },
                                                      child: CachedNetworkImage(
                                                        imageUrl:
                                                            '$imageUrl${recommentations.results[index].posterPath}',
                                                      ),
                                                    );
                                            })
                                      ],
                                    ),
                                  );
                          } else if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(50.0),
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          } else if (snapshot.data == null) {
                            return const Text('No recommendations available');
                          } else if (snapshot.hasError) {
                            print('error is : ${snapshot.error.runtimeType}');
                            return const Text('some error occurs');
                          } else {
                            return const Text('something happened');
                          }
                        })
                  ],
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(50.0),
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  ),
                );
              } else {
                return const SizedBox();
              }
            }),
      ),
    );
  }
}
