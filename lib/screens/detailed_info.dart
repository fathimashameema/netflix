import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:netflix/common/utils.dart';
import 'package:netflix/models/movie_details.dart';
import 'package:netflix/models/movie_recommentations.dart';
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
  late Future<MovieRecommentations> movieRecommentations;

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
                String genre =
                    data!.genres.map((genre) => genre.name).join(', ');
                return Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                            height: MediaQuery.of(context).size.height * 0.5,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(
                                  '$imageUrl${data!.posterPath}',
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
                                      icon: Icon(
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
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            data.title,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              Text(
                                data.releaseDate.year.toString(),
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 17,
                                ),
                              ),
                              SizedBox(
                                width: 30,
                              ),
                              Text(
                                genre,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 17,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            data.overview,
                            maxLines: 6,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    FutureBuilder(
                        future: movieRecommentations,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final recommentations = snapshot.data;
                            return recommentations!.results.isEmpty
                                ? SizedBox()
                                : Column(
                                    children: [
                                      Text(
                                        'More like this :',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      SizedBox(
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
                                            return CachedNetworkImage(
                                              imageUrl:
                                                  '$imageUrl${recommentations.results[index].posterPath}',
                                            );
                                          })
                                    ],
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
                          } else {
                            return SizedBox();
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
                return SizedBox();
              }
            }),
      ),
    );
  }
}
