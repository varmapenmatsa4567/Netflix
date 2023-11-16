import 'dart:math';

import 'package:external_video_player_launcher/external_video_player_launcher.dart';
import 'package:flutter/material.dart';
import 'package:netflix/providers/favourites_provider.dart';
import 'package:netflix/screens/video_screen.dart';
import 'package:provider/provider.dart';

class EpisodeCard extends StatelessWidget {
  String episode;
  int episodeNumber;
  String episodeId;
  EpisodeCard({
    required this.episode,
    required this.episodeNumber,
    required this.episodeId,
  });

  @override
  Widget build(BuildContext context) {
    FavouritesProvider fp =
        Provider.of<FavouritesProvider>(context, listen: true);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Text(
            "Episode $episodeNumber",
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w500,
            ),
          ),
          Spacer(),
          IconButton(
            splashRadius: 20,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SamplePlayer(
                    url: episode,
                    movieId: episodeId,
                    sec: fp.watched[episodeId] ?? 0,
                  ),
                ),
              ).then((value) {
                fp.setVideo(false);
              });
              fp.setVideo(true);
            },
            icon: Icon(Icons.play_arrow_sharp, color: Colors.white),
          ),
          IconButton(
            splashRadius: 20,
            onPressed: () {
              ExternalVideoPlayerLauncher.launchOtherPlayer(
                  episode, "video/*", {});
            },
            icon: Icon(Icons.ondemand_video, color: Colors.white),
          ),
          IconButton(
            splashRadius: 20,
            onPressed: () {},
            icon: Icon(Icons.download, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
