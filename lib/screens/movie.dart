import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:external_video_player_launcher/external_video_player_launcher.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:netflix/providers/download_provider.dart';
import 'package:netflix/providers/favourites_provider.dart';
import 'package:netflix/screens/video_screen.dart';
import 'package:netflix/widgets/action_card.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Movies extends StatefulWidget with WidgetsBindingObserver {
  DocumentSnapshot movie;
  Movies({
    required this.movie,
  });

  @override
  State<Movies> createState() => _MoviesState();
}

class _MoviesState extends State<Movies> {
  late FavouritesProvider fp;

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DocumentSnapshot movie = widget.movie;
    FavouritesProvider fp =
        Provider.of<FavouritesProvider>(context, listen: true);
    DownloadProvider dp = Provider.of<DownloadProvider>(context, listen: true);
    // var date = movie['date'].toDate().year.toString();
    List<String> genres = movie['category'].cast<String>();
    // String category = genres.join(", ");
    Uri url = Uri.parse(movie['url']);
    List<String> lang = [];
    List<String> langs = [
      'Telugu',
      'Hindi',
      'Tamil',
      'Malayalam',
      'Kannada',
      'English',
    ];
    for (int i = 0; i < langs.length; i++) {
      if (movie['tags'].contains(langs[i].toLowerCase())) {
        lang.add(langs[i]);
      }
    }
    String language = lang.join(", ");
    return Center(
      child: ListView(
        children: [
          Column(
            children: [
              SizedBox(
                height: 10,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: movie['image'],
                  height: 300,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                movie['name'],
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              height: 45,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SamplePlayer(
                        url: url.toString(),
                        movieId: movie.id,
                        sec: fp.watched[movie.id] ?? 0,
                      ),
                    ),
                  ).then((value) {
                    fp.setVideo(false);
                  });
                  fp.setVideo(true);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.play_arrow,
                      color: Colors.black,
                    ),
                    Text(
                      fp.watched[movie.id] != null
                          ? "Continue Watching"
                          : "Play",
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              height: 45,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      const Color.fromARGB(255, 39, 38, 38)),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                onPressed: () {
                  // launchUrl(url);
                  // requestDownload(
                  //     url.toString(), movie.id, movie['name'] + '.mkv');
                  dp.addDownload(movie['name'], movie.id, url.toString());
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.download,
                      color: Colors.white,
                    ),
                    Text(
                      "Download",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (fp.watched[movie.id] != null && fp.watched[movie.id] != 0)
                ActionCard(
                  icon: Icons.replay,
                  text: "Start Over",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SamplePlayer(
                          url: url.toString(),
                          movieId: movie.id,
                          sec: 0,
                        ),
                      ),
                    );
                  },
                ),
              ActionCard(
                icon: Icons.play_circle_outline,
                text: "Trailer",
                onTap: () {
                  launchUrl(Uri.parse(movie['trailer']));
                },
              ),
              ActionCard(
                icon:
                    fp.favourites.contains(movie.id) ? Icons.check : Icons.add,
                text: "Watchlist",
                onTap: () {
                  if (fp.favourites.contains(movie.id)) {
                    fp.removeFavourite(movie.id);
                  } else {
                    fp.addFavourite(movie.id);
                  }
                },
              ),
              ActionCard(
                icon: Icons.ondemand_video,
                text: "Play with",
                onTap: () {
                  ExternalVideoPlayerLauncher.launchOtherPlayer(
                      url.toString(), "video/*", {'title': movie['name']});
                },
              ),
              ActionCard(
                icon: Icons.download,
                text: "Download",
                onTap: () {
                  int seconds = 0;
                  seconds = fp.watched[movie.id] ?? 0;
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Movie Added'),
                      content: Text(seconds.toString()),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Ok'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ExpandableText(
              movie['overview'],
              expandText: '',
              animation: true,
              expandOnTextTap: true,
              collapseOnTextTap: true,
              maxLines: 3,
              linkStyle: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: <Widget>[
                for (int i = 0; i < genres.length; i++) ...[
                  Text(
                    genres[i],
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  if (i <
                      genres.length - 1) // Add icon only if not the last item
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Icon(
                        Icons.circle, // You can use any icon here
                        color: Colors.white,
                        size: 6, // Set the size of the circle icon
                      ),
                    ),
                ]
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "IMDb ${movie['rating']}",
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text(
                  DateFormat('MMM d, yyyy').format(movie['date'].toDate()),
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Icon(
                  Icons.circle,
                  color: Colors.grey,
                  size: 5,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  movie['duration'],
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Languages",
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              language,
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
