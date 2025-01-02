import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:netflix/common/utils.dart';
import 'package:netflix/models/popular_movies.dart';
import 'package:netflix/models/searched_movies.dart';
import 'package:netflix/screens/detailed_info.dart';
import 'package:netflix/services/api_services.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  ApiServices apiServices = ApiServices();
  late Future<PopularMovies> popularMovies;
  TextEditingController textEditingController = TextEditingController();

  SearchedMovies? searchedMovie;
  void search(String keyWord) {
    apiServices.getSearchedovie(keyWord).then((results) {
      setState(() {
        searchedMovie = results;
      });
    });
  }

  @override
  void initState() {
    popularMovies = apiServices.getPopularMovies();
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20.0,
                    right: 20,
                    top: 20,
                  ),
                  child: CupertinoSearchTextField(
                    style: const TextStyle(color: Colors.white),
                    backgroundColor: Colors.grey.withOpacity(0.3),
                    padding: const EdgeInsets.all(10),
                    controller: textEditingController,
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.grey,
                    ),
                    suffixIcon: const Icon(
                      Icons.cancel,
                      color: Colors.grey,
                    ),
                    onChanged: (value) {
                      if (value.isEmpty) {
                      } else {
                        search(textEditingController.text);
                      }
                    },
                  ),
                ),
                textEditingController.text.isEmpty
                    ? FutureBuilder<PopularMovies>(
                        future: popularMovies,
                        builder: (context, snapshot) {
                          var data = snapshot.data?.results;
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Padding(
                              padding: EdgeInsets.all(50.0),
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            );
                          }
                          if (snapshot.data == null) {
                            return const SizedBox.shrink();
                          }
                          return Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Top Searches',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: snapshot.data!.results.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (ctx) =>
                                                        DetailedInfo(
                                                          movieId: snapshot
                                                              .data!
                                                              .results[index]
                                                              .id,
                                                        )));
                                          },
                                          child: Row(
                                            children: [
                                              Image.network(
                                                '$imageUrl${data?[index].posterPath}',
                                                height: 150,
                                                width: 100,
                                                fit: BoxFit.fitHeight,
                                              ),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              SizedBox(
                                                width: 200,
                                                child: Text(
                                                  data![index].title,
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                              ],
                            ),
                          );
                        })
                    : searchedMovie!.results.isEmpty
                        ? const Text('No movie matches the search')
                        : GridView.builder(
                            shrinkWrap: true,
                            // padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: searchedMovie?.results.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 15,
                              crossAxisSpacing: 10,
                              childAspectRatio: 1.2 / 2,
                            ),
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  // Navigator.of(context).push(MaterialPageRoute(
                                  //     builder: (ctx) => DetailedInfo(
                                  //           movieId: searchedMovie!
                                  //               .results[index].id,
                                  //         )));
                                },
                                child: Column(
                                  children: [
                                    searchedMovie!
                                                .results[index].backdropPath !=
                                            null
                                        ? CachedNetworkImage(
                                            imageUrl:
                                                '$imageUrl${searchedMovie!.results[index].backdropPath}',
                                            height: 170,
                                            // fit: BoxFit.cover,
                                          )
                                        : Image.asset(
                                            'assets/netflix.png',
                                            height: 170,
                                          ),
                                    Text(
                                      overflow: TextOverflow.ellipsis,
                                      searchedMovie!.results[index].title,
                                      maxLines: 2,
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
