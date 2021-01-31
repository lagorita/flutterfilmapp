import 'package:flutter/material.dart';
import 'package:flutter_filmapp/state/state_manager.dart';
import 'package:flutter_riverpod/all.dart';

class FilmScenes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        var film = watch(filmSelected).state;
        return Scaffold(
          appBar: AppBar(
            title: Text("${film.name.toUpperCase()}"),
          ),
          body: film.scenes != null && film.scenes.length > 0
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                      itemCount: film.scenes.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            context.read(sceneSelected).state=film.scenes[index];
                            Navigator.pushNamed(context, "/scenes");
                          },
                          child: Column(
                            children: [
                              ListTile(
                                title: Text("${film.scenes[index].sceneNames}"),
                              ),
                              Divider(
                                thickness: 1,
                              ),
                            ],
                          ),
                        );
                      }),
                )
              : Center(
                  child: Text("We are translating this film."),
                ),
        );
      },
    );
  }
}
