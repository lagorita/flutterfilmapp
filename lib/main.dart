import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_filmapp/module/film.dart';
import 'package:flutter_filmapp/screens/filmscenes.dart';
import 'package:flutter_filmapp/screens/watch_scenes.dart';
import 'package:flutter_filmapp/state/state_manager.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseApp app = await Firebase.initializeApp();
  runApp(ProviderScope(child: MyApp(app: app)));
}

class MyApp extends StatelessWidget {
  FirebaseApp app;
  MyApp({this.app});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        "/films": (context) => FilmScenes(),
        "/scenes": (context) => WatchScenes(),
      },
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Film App', app: app),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.app}) : super(key: key);

  final String title;
  final FirebaseApp app;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DatabaseReference _bannerRef, _filmRef;
  List<Film> listFilm = List<Film>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final FirebaseDatabase database = FirebaseDatabase();
    _bannerRef = database.reference().child("Banners");
    _filmRef = database.reference().child("Films");
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, _) {
        var searchEnable = watch(isSearch).state;
        return Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                icon: !context.read(isSearch).state
                    ? Icon(Icons.search)
                    : Icon(Icons.close),
                onPressed: () => context.read(isSearch).state =
                    !context.read(isSearch).state,
              )
            ],
            title: searchEnable
                ? TypeAheadField(
                    textFieldConfiguration: TextFieldConfiguration(
                      decoration: InputDecoration(
                          hintText: "Film name or category",
                          hintStyle: TextStyle(color: Colors.white60)),
                      autofocus: false,
                      style: TextStyle(
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                          fontSize: 18,
                          letterSpacing: 0.7,
                          decorationThickness: 0),
                    ),
                    suggestionsCallback: (searchString) async {
                      return await searchComic(searchString);
                    },
                    itemBuilder: (context, film) {
                      return Column(
                        children: [
                          ListTile(
                            leading: Image.network(film.cover),
                            title: Text("${film.name}"),
                            subtitle: film.category == null
                                ? Text("")
                                : Text("${film.category}"),
                          ),
                          Divider(
                            thickness: 1,
                          )
                        ],
                      );
                    },
                    onSuggestionSelected: (film) {
                      context.read(filmSelected).state = film;
                      Navigator.pushNamed(context, "/films");
                    })
                : Text(
                    widget.title,
                    style: TextStyle(color: Colors.white),
                  ),
            centerTitle: true,
          ),
          body: FutureBuilder<List<String>>(
            future: getBanners(_bannerRef),
            builder: (context, snapshot) {
              if (snapshot.hasData)
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CarouselSlider(
                        items: snapshot.data
                            .map((e) => Builder(builder: (context) {
                                  return Image.network(
                                    e,
                                    fit: BoxFit.cover,
                                  );
                                }))
                            .toList(),
                        options: CarouselOptions(
                            autoPlay: true,
                            enlargeCenterPage: true,
                            viewportFraction: 1,
                            initialPage: 0,
                            height: MediaQuery.of(context).size.height / 3)),
                    Row(
                      children: [
                        Expanded(
                            flex: 4,
                            child: Container(
                              color: Colors.deepPurple,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "NEW FILM HERE!",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            )),
                        Expanded(
                            child: Container(
                          color: Colors.black,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(""),
                          ),
                        ))
                      ],
                    ),
                    FutureBuilder(
                        future: getFilm(_filmRef),
                        builder: (context, snapshot) {
                          if (snapshot.hasError)
                            return Center(
                              child: Text("${snapshot.error}"),
                            );
                          else if (snapshot.hasData) {
                            listFilm = new List<Film>();
                            snapshot.data.forEach((item) {
                              var film =
                                  Film.fromJson(json.decode(json.encode(item)));
                              listFilm.add(film);
                            });
                            return Expanded(
                                child: GridView.count(
                              crossAxisCount: 2,
                              childAspectRatio: 0.8,
                              mainAxisSpacing: 1,
                              crossAxisSpacing: 1,
                              children: listFilm.map((film) {
                                return GestureDetector(
                                  onTap: () {
                                    context.read(filmSelected).state = film;
                                    Navigator.pushNamed(context, "/films");
                                  },
                                  child: Card(
                                    elevation: 22,
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        Image.network(
                                          film.cover,
                                          fit: BoxFit.cover,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(8),
                                              color: Color(0xAA434343),
                                              child: Text(
                                                "${film.point} (IMDB)",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            )
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(8),
                                              color: Color(0xAA434343),
                                              child: Text(
                                                "${film.name}",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ));
                          }
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        })
                  ],
                );
              else if (snapshot.hasError)
                return Center(
                  child: Text("${snapshot.error}"),
                );
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        );
      },
    );
  }

  Future<List<dynamic>> getFilm(DatabaseReference filmRef) {
    return filmRef.once().then((snapshot) => snapshot.value);
  }

  Future<List<String>> getBanners(DatabaseReference bannerRef) {
    return bannerRef
        .once()
        .then((snapshot) => snapshot.value.cast<String>().toList());
  }

  Future<List<Film>> searchComic(String searchString) async {
    return listFilm
        .where((film) =>
            film.name.toLowerCase().contains(searchString.toLowerCase()) ||
            (film.category != null &&
                film.category
                    .toLowerCase()
                    .contains(searchString.toLowerCase())))
        .toList();
  }
}
