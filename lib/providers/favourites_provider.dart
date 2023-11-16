import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class FavouritesProvider extends ChangeNotifier {
  List<String> _favourites = [];
  Map<dynamic, dynamic> _watched = {};
  Map<dynamic, dynamic> _downloads = {};
  bool _video = false;

  List<String> get favourites => _favourites;
  Map<dynamic, dynamic> get watched => _watched;
  Map<dynamic, dynamic> get downloads => _downloads;
  bool get video => _video;

  Box fav = Hive.box<List<String>>('favourites');
  Box watch = Hive.box<Map<dynamic, dynamic>>('watched');
  Box download = Hive.box<Map<dynamic, dynamic>>('downloads');

  FavouritesProvider() {
    _favourites = [];
    _favourites =
        fav.get('favourites', defaultValue: [].cast<String>()).cast<String>();
    _watched = watch.get('watched', defaultValue: {});
    _downloads = download.get('downloads', defaultValue: {});
  }

  void addDownloads(dynamic movieId, dynamic path) {
    _downloads[movieId] = path;
    download.put('downloads', _downloads);
    notifyListeners();
  }

  void removeDownloads(dynamic movieId) {
    _downloads.remove(movieId);
    download.put('downloads', _downloads);
    notifyListeners();
  }

  void setVideo(bool val) {
    _video = val;
    notifyListeners();
  }

  void addWatched(dynamic movieId, dynamic sec) {
    _watched[movieId] = sec;
    watch.put('watched', _watched);
    // notifyListeners();
  }

  void addFavourite(String movieId) {
    _favourites.add(movieId);
    fav.put('favourites', _favourites);
    notifyListeners();
  }

  void removeFavourite(String movieId) {
    _favourites.remove(movieId);
    fav.put('favourites', _favourites);
    notifyListeners();
  }
}
