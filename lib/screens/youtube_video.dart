import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubeVideo extends StatefulWidget {
  const YoutubeVideo({super.key});

  @override
  State<YoutubeVideo> createState() => _YoutubeVideoState();
}

class _YoutubeVideoState extends State<YoutubeVideo> {
  YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: 'HNnt00swZ5Q',
    flags: YoutubePlayerFlags(
      // hideControls: true,
      autoPlay: true,
      mute: true,
    ),
  );
  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        topActions: [],
        bottomActions: [ProgressBar(isExpanded: true)],
      ),
      builder: (context, player) => Scaffold(
        backgroundColor: Colors.black,
        body: ListView(
          children: [
            SizedBox(
              height: 50,
            ),
            player,
          ],
        ),
      ),
    );
  }
}
