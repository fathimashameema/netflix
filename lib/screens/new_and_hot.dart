import 'package:flutter/material.dart';
import 'package:netflix/common/utils.dart';
import 'package:netflix/models/popular_movies.dart';
import 'package:netflix/models/upcoming_movies.dart';
import 'package:netflix/services/api_services.dart';
import 'package:netflix/widgets/coming_soon_widget.dart';

class NewAndHot extends StatefulWidget {
  const NewAndHot({super.key});

  @override
  State<NewAndHot> createState() => _NewAndHotState();
}

class _NewAndHotState extends State<NewAndHot> {
  late Future<UpcomingMovies> comingSoon;
  late Future<PopularMovies> everyoneWatching;
  ApiServices apiServices = ApiServices();
  @override
  void initState() {
    comingSoon = apiServices.getUpcomingMovies();
    everyoneWatching = apiServices.getPopularMovies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: const Text(
              'New & Hot',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.black,
            actions: [
              const Icon(
                Icons.cast,
                color: Colors.white,
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
            bottom: TabBar(
              tabs: const [
                Tab(
                  text: '  🍿 Coming Soon   ',
                ),
                Tab(
                  text: "  🔥 Everyone's Watching  ",
                ),
              ],
              dividerColor: Colors.black,
              isScrollable: false,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.white,
              ),
              labelColor: Colors.black,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              unselectedLabelColor: Colors.white,
            ),
          ),
          body: TabBarView(children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder(
                future: comingSoon,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final data = snapshot.data;
                    return ListView.builder(
                      itemCount: data!.results.length,
                      itemBuilder: (context, index) {
                        final date = data.results[index].releaseDate;
                        return ComingSoonWidget(
                          imageUrl:
                              '$imageUrl${data.results[index].posterPath}',
                          overview: data.results[index].overview,
                          name: data.results[index].originalTitle,
                          month: date.month,
                          day: date.day,
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(50.0),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder(
                future: everyoneWatching,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final data = snapshot.data;
                    return ListView.builder(
                      itemCount: data!.results.length,
                      itemBuilder: (context, index) {
                        final date = data.results[index].releaseDate;
                        return ComingSoonWidget(
                          imageUrl:
                              '$imageUrl${data.results[index].posterPath}',
                          overview: data.results[index].overview,
                          name: data.results[index].originalTitle,
                          month: date.month,
                          day: date.day,
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(50.0),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
