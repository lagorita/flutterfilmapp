import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_filmapp/state/state_manager.dart';
import 'package:flutter_riverpod/all.dart';

class WatchScenes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, _) {
        var film = watch(filmSelected).state;

        return Scaffold(
          appBar: AppBar(
            title: Text("${film.name.toUpperCase()}"),
          ),
          body: Center(
            child: context.read(sceneSelected).state.photos == null ||
                    context.read(sceneSelected).state.photos.length == 1
                ? Center(
                    child: Text("This scenes is translating...."),
                  )
                : CarouselSlider(
                    items: context
                        .read(sceneSelected)
                        .state
                        .photos
                        .map((e) => Builder(builder: (context) {
                              return Image.network(
                                e,
                                fit: BoxFit.cover,
                              );
                            }))
                        .toList(),
                    options: CarouselOptions(
                        autoPlay: false,
                        height: MediaQuery.of(context).size.height / 2,
                        enlargeCenterPage: true,
                        viewportFraction: 1,
                        initialPage: 0,
                        enableInfiniteScroll: false),
                  ),
          ),
        );
      },
    );
  }
}
