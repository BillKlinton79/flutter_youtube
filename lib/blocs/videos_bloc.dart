import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter_tube/models/video.dart';

import '../api.dart';

class VideosBloc implements BlocBase {
  Api api;
  List<Video> listVideos;

  final _videosController = StreamController<List<Video>>();

  Stream get outVideos => _videosController.stream;

  final _searchController = StreamController<String>();

  Sink get inSearch => _searchController.sink;

  VideosBloc() {
    api = Api();
    _searchController.stream.listen(_search);
  }

  void _search(String search) async {
    if(search != null){
      _videosController.sink.add([]);
      listVideos = await api.search(search);
    }else{
      listVideos += await api.nextPage();
    }
    _videosController.sink.add(listVideos);
  }

  @override
  void dispose() {
    _videosController.close();
    _searchController.close();
  }

  @override
  void addListener(listener) {
  }

  @override
  bool get hasListeners => null;

  @override
  void notifyListeners() {
  }

  @override
  void removeListener(listener) {
  }
}
