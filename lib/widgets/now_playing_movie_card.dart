import 'package:flutter/material.dart';
import 'package:netflix/common/utils.dart';
import 'package:netflix/models/now_playing_movies.dart';
import 'package:netflix/screens/detailed_info.dart';

class NowPlayingMovieCard extends StatelessWidget {
  final Future<NowPlayingMovies> movies;
  final String header;
  const NowPlayingMovieCard(
      {super.key, required this.movies, required this.header});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: movies,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Padding(
              padding: EdgeInsets.all(50.0),
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            );
          }
          final data = snapshot.data?.results;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                header,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: data?.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (ctx) =>
                                  DetailedInfo(movieId: data![index].id)));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20)),
                          child: Image.network(
                            '$imageUrl${data?[index].posterPath}',
                          ),
                        ),
                      );
                    }),
              )
            ],
          );
        });
  }
}
