import 'package:flutter/material.dart';
import 'package:netflix/screens/home_screen.dart';
import 'package:netflix/screens/new_and_hot.dart';
import 'package:netflix/screens/search.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        bottomNavigationBar: Container(
          color: Colors.black,
          height: 50,
          child: const TabBar(
            tabs: [
              Tab(
                text: 'Home',
                icon: Icon(Icons.home),
              ),
              Tab(
                text: 'Search',
                icon: Icon(Icons.search),
              ),
              Tab(
                icon: Icon(Icons.video_library_outlined),
                text: 'New & Hot',
              )
            ],
            dividerColor: Colors.transparent,
            indicatorColor: Colors.transparent,
            labelColor: Colors.white,
            unselectedLabelColor: Color(0xff999999),
          ),
        ),
        body: const TabBarView(children: [
          HomeScreen(),
          Search(),
          NewAndHot(),
        ]),
      ),
    );
  }
}
