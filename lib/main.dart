import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tube/blocs/favorite_bloc.dart';
import 'package:flutter_tube/pages/home.dart';

import 'api.dart';
import 'blocs/videos_bloc.dart';

void main() {

  Api api = Api();
  api.search("tft");

  runApp(BlocProvider(
    blocs: [Bloc((i) => VideosBloc()), Bloc((i) => FavoriteBloc())],
    child: MaterialApp(
      title: "FlutterTube",
      home: Home(),
    ),
  ));
}
