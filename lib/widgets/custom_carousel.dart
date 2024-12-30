import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:netflix/common/utils.dart';
import 'package:netflix/models/top_rated_series.dart';
import 'package:netflix/screens/detailed_info.dart';

class CustomCarousel extends StatelessWidget {
  final TopRatedSeries series;
  const CustomCarousel({super.key, required this.series});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      height: (size.height * 0.33 < 300) ? 300 : size.height * 0.33,
      child: CarouselSlider.builder(
        itemCount: series.results.length,
        itemBuilder: (context, index, realIndex) {
          var url = series.results[index].backdropPath.toString();
          return GestureDetector(
              onTap: () {
                // Navigator.of(context).push(MaterialPageRoute(
                //     builder: (ctx) => DetailedInfo(
                //           movieId: series.results[index].id,
                //         )));
              },
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    CachedNetworkImage(imageUrl: '$imageUrl$url'),
                    const SizedBox(
                      height: 25,
                    ),
                    Text(series.results[index].name),
                  ],
                ),
              ));
        },
        options: CarouselOptions(
          height: (size.height * 0.33 < 300) ? 300 : size.height * 0.33,
          autoPlay: true,
          reverse: false,
          aspectRatio: 16 / 9,
          enlargeCenterPage: true,
          autoPlayInterval: const Duration(seconds: 2),
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
        ),
      ),
    );
  }
}
