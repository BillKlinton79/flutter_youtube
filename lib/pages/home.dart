import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tube/blocs/favorite_bloc.dart';
import 'package:flutter_tube/blocs/videos_bloc.dart';
import 'package:flutter_tube/delegates/data_search.dart';
import 'package:flutter_tube/models/video.dart';
import 'package:flutter_tube/widgets/video_tile.dart';

import 'favorites.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _videosBloc = BlocProvider.getBloc<VideosBloc>();
    var _favoriteBloc = BlocProvider.getBloc<FavoriteBloc>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Container(
          height: 40,
          child: Image.asset("images/youtube_logo.png"),
        ),
        elevation: 0,
        actions: <Widget>[
          Align(
            alignment: Alignment.center,
            child: StreamBuilder<Map<String, Video>>(
                stream: _favoriteBloc.outFav,
                initialData: {},
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text("${snapshot.data.length}");
                  } else {
                    return Container();
                  }
                }),
          ),
          IconButton(
            icon: Icon(
              Icons.star,
            ),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => Favorites()));
            },
          ),
          IconButton(
            icon: Icon(
              Icons.search,
            ),
            onPressed: () async {
              String result =
                  await showSearch(context: context, delegate: DataSearch());
              if (result != null) {
                _videosBloc.inSearch.add(result);
              }
            },
          )
        ],
      ),
      backgroundColor: Colors.black,
      body: StreamBuilder(
        stream: _videosBloc.outVideos,
        initialData: [],
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemBuilder: (context, index) {
                if (index < snapshot.data.length) {
                  return VideoTile(snapshot.data[index]);
                } else if (index > 1) {
                  _videosBloc.inSearch.add(null);
                  return Container(
                    height: 40,
                    width: 40,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                    ),
                  );
                } else {
                  return Container();
                }
              },
              itemCount: snapshot.data.length + 1,
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
