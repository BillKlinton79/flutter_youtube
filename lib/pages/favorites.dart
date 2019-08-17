import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tube/blocs/favorite_bloc.dart';
import 'package:flutter_tube/models/video.dart';
import 'package:flutter_youtube/flutter_youtube.dart';

import '../api.dart';

class Favorites extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final blocFavorites = BlocProvider.getBloc<FavoriteBloc>();
    return Scaffold(
      appBar: AppBar(
        title: Text("Favoritos"),
        centerTitle: true,
        backgroundColor: Colors.black87,
      ),
      backgroundColor: Colors.black87,
      body: StreamBuilder<Map<String, Video>>(
          stream: blocFavorites.outFav,
          initialData: {},
          builder: (context, snapshot) {
            return ListView(
              children: snapshot.data.values.map((item) {
                return InkWell(
                  child: Row(
                    children: <Widget>[
                      Container(
                        height: 50,
                        width: 100,
                        child: Image.network(item.thumb),
                      ),
                      Expanded(
                        child: Text(
                          item.title,
                          style: TextStyle(color: Colors.white70),
                          maxLines: 2,
                        ),
                      )
                    ],
                  ),
                  onTap: () {
                    FlutterYoutube.playYoutubeVideoById(apiKey:  API_KEY, videoId: item.id);
                  },
                  onLongPress: () {
                    blocFavorites.toggleFavorite(item);
                  },
                );
              }).toList(),
            );
          }),
    );
  }
}
