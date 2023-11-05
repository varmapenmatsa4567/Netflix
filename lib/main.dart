import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:netflix/firebase_options.dart';
import 'package:netflix/navigator_page.dart';
import 'package:netflix/providers/favourites_provider.dart';
import 'package:netflix/screens/search_screen.dart';
import 'package:netflix/screens/youtube_video.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FlutterDownloader.initialize(debug: true);
  await Hive.initFlutter();
  await Hive.openBox<List<String>>('favourites');
  await Hive.openBox<Map<dynamic, dynamic>>('watched');

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.black, // Status bar color
    statusBarIconBrightness: Brightness.light, // Status bar icons' color
  ));
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => FavouritesProvider()),
    ],
    child: App(),
  ));
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _pageIndex = 0;

  List<String> tabNames = [
    'Home',
    'Search',
    'Watchlist',
    'Downloads',
  ];

  Map<int, GlobalKey> navigatorKeys = {
    0: GlobalKey(),
    1: GlobalKey(),
    2: GlobalKey(),
    3: GlobalKey(),
  };

  List<Widget> getPages() {
    List<Widget> pages = [];
    for (int i = 0; i < tabNames.length; i++) {
      pages.add(NavigatorPage(
        tabName: tabNames[i],
        navigatorKey: navigatorKeys[i]!,
      ));
    }
    return pages;
  }

  @override
  Widget build(BuildContext context) {
    var fp = Provider.of<FavouritesProvider>(context, listen: true);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: !fp.video
          ? AppBar(
              backgroundColor: Colors.black.withAlpha(200),
              title: Text(tabNames[_pageIndex]),
            )
          : null,
      backgroundColor: Colors.black,
      body: WillPopScope(
        onWillPop: () async {
          return !await Navigator.maybePop(
              navigatorKeys[_pageIndex]!.currentState!.context);
        },
        child: IndexedStack(
          index: _pageIndex,
          children: getPages(),
        ),
      ),
      bottomNavigationBar: !fp.video
          ? BottomNavigationBar(
              backgroundColor: Colors.black,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.grey,
              currentIndex: _pageIndex,
              onTap: (index) {
                setState(() {
                  _pageIndex = index;
                });
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                  backgroundColor: Colors.black,
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.search),
                  label: 'Search',
                  backgroundColor: Colors.black,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.list),
                  label: 'Watchlist',
                  backgroundColor: Colors.black,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.file_download),
                  label: 'Downloads',
                  backgroundColor: Colors.black,
                ),
              ],
            )
          : null,
    );
  }
}
