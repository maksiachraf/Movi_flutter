import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:movie_db/main.dart';
import 'package:movie_db/src/model/movie.dart';
import 'package:http/http.dart' as http;

class MyTrendingPage extends StatefulWidget {
  @override
  MyTrendingPage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyTrendingPageState createState() => _MyTrendingPageState();
}

class _MyTrendingPageState extends State<MyTrendingPage> {
  List<Movie> _trendingMovies = [];

  Future<List<Movie>> fetchList(routeUrl) async {
    final response = await http.get(Uri.parse(routeUrl));
    // ignore: deprecated_member_use
    List<Movie> movieList = [];
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var list = json.decode(response.body);

      for (var movie in list['results']) {
        movieList.add(Movie.fromJson(movie));
      }
      return movieList;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception(
          "Failed to load Movie List" + response.statusCode.toString());
    }
  }

  final trendingUrl =
      'https://api.themoviedb.org/3/trending/movie/day?api_key=061e411e417766bfc7b370d08d2fbd49&language=en';

  @override
  void initState() {
    fetchList(trendingUrl).then((value) {
      setState(() {
        _trendingMovies.addAll(value);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return Card(
            child: Column(
              children: <Widget>[
                Text(_trendingMovies[index].title),
                Text(_trendingMovies[index].detail),
              ],
            ),
          );
        },
        itemCount: _trendingMovies.length,
      ),
    );
  }
}
