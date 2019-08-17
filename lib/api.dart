import 'dart:convert';

import 'package:http/http.dart' as http;

import 'models/video.dart';

const API_KEY = "AIzaSyB3q58ntLEPMoNEj8r_XT8olKts68Kk_y0";

class Api {

  String _search;
  String _nextToken;

  Future<List<Video>> search(String search) async {
    _search = search;
    var response = await http.get(
        "https://www.googleapis.com/youtube/v3/search?part=snippet&q=$search&type=video&key=$API_KEY&maxResults=10");
    return decode(response);
  }

  Future<List<Video>> nextPage() async{
    var response = await http.get(
        "https://www.googleapis.com/youtube/v3/search?part=snippet&q=$_search&type=video&key=$API_KEY&maxResults=10&pageToken=$_nextToken");
    return decode(response);
  }

  List<Video> decode(http.Response response) {
    if (response.statusCode == 200) {
      var decoded = json.decode(response.body);

      _nextToken = decoded["nextPageToken"];

      List<Video> videos = decoded["items"].map<Video>((item) {
        return Video.fromJson(item);
      }).toList();

      return videos;
    }else{
      throw Exception("Failed to load Videos!");
    }
  }
}
