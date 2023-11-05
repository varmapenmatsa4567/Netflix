import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class FavouritesProvider extends ChangeNotifier {
  List<String> _favourites = [];
  Map<dynamic, dynamic> _watched = {};
  bool _video = false;

  List<String> get favourites => _favourites;
  Map<dynamic, dynamic> get watched => _watched;
  bool get video => _video;

  Box fav = Hive.box<List<String>>('favourites');
  Box watch = Hive.box<Map<dynamic, dynamic>>('watched');

  FavouritesProvider() {
    _favourites = [];
    _favourites =
        fav.get('favourites', defaultValue: [].cast<String>()).cast<String>();
    _watched = watch.get('watched', defaultValue: {});
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
