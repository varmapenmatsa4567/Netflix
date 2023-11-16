import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:netflix/providers/favourites_provider.dart';
import 'package:netflix/widgets/episode_card.dart';
import 'package:provider/provider.dart';

class Series extends StatefulWidget {
  DocumentSnapshot movie;
  Series({
    required this.movie,
  });

  @override
  State<Series> createState() => _SeriesState();
}

class _SeriesState extends State<Series> {
  late FavouritesProvider fp;
  String currentSeason = "Season 1";
  List<String> seasons = [];
  Map listOfEpisodes = {};

  void initState() {
    DocumentSnapshot movie = widget.movie;
    Map episodes = movie['episodes'];
    seasons = [];
    for (int i = 0; i < episodes.length; i++) {
      seasons.add("Season ${i + 1}");
      listOfEpisodes["Season ${i + 1}"] = episodes[(i + 1).toString()];
    }
    currentSeason = seasons[0];
    print(listOfEpisodes);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DocumentSnapshot movie = widget.movie;
    FavouritesProvider fp =
        Provider.of<FavouritesProvider>(context, listen: true);
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

    // List<String> seasons = [];

    // String currentSeason = seasons[0];
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
          SizedBox(
            height: 10,
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
          SizedBox(
            height: 5,
          ),
          Align(
            alignment: Alignment.center,
            child: DropdownButton(
              value: currentSeason,
              alignment: AlignmentDirectional.center,
              borderRadius: BorderRadius.circular(10),
              icon: Icon(
                Icons.arrow_drop_down,
                color: Colors.white,
              ),
              dropdownColor: const Color.fromARGB(255, 102, 101, 101),
              items: seasons.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  currentSeason = value.toString();
                  print(listOfEpisodes[currentSeason]);
                  print(currentSeason);
                });
              },
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Column(
            children: [
              for (int i = 0; i < listOfEpisodes[currentSeason].length; i++)
                EpisodeCard(
                  episode: listOfEpisodes[currentSeason][i],
                  episodeNumber: i + 1,
                  episodeId: movie.id + currentSeason + (i + 1).toString(),
                ),
            ],
          ),
          // EpisodeCard(),
        ],
      ),
    );
  }
}
