import 'package:flutter/material.dart';
import 'package:netflix/screens/favourites_screen.dart';
import 'package:netflix/screens/movies_view.dart';
import 'package:netflix/screens/search_screen.dart';

class NavigatorPage extends StatefulWidget {
  NavigatorPage({
    required this.tabName,
    required this.navigatorKey,
  });

  final String tabName;
  final GlobalKey navigatorKey;

  @override
  State<NavigatorPage> createState() => _NavigatorPageState();
}

class _NavigatorPageState extends State<NavigatorPage> {
  Widget getPage() {
    if (widget.tabName == 'Home') {
      return MoviesView();
    } else if (widget.tabName == 'Watchlist') {
      return FavouritesScreen();
    } else if (widget.tabName == 'Search') {
      return SearchScreen();
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: widget.navigatorKey,
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (context) {
            return Scaffold(
              extendBodyBehindAppBar: true,
              backgroundColor: Colors.black,
              body: getPage(),
            );
          },
        );
      },
    );
  }
}
