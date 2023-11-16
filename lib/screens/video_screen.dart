import 'package:flutter/material.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/services.dart';
import 'package:netflix/providers/favourites_provider.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class SamplePlayer extends StatefulWidget {
  String url;
  String movieId;
  int sec;
  SamplePlayer({
    required this.url,
    required this.movieId,
    this.sec = 0,
  });

  @override
  State<SamplePlayer> createState() => _SamplePlayerState();
}

class _SamplePlayerState extends State<SamplePlayer> {
  late FlickManager flickManager;
  late VideoPlayerController _controller;
  late FavouritesProvider fp;
  @override
  void initState() {
    super.initState();
    if (widget.sec != 0) {
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.url),
        videoPlayerOptions: VideoPlayerOptions(),
      )..initialize().then((_) {
          setState(() {
            _controller.seekTo(Duration(seconds: widget.sec));
          });
        });
    } else {
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.url),
        videoPlayerOptions: VideoPlayerOptions(),
      );
    }

    flickManager = FlickManager(
      videoPlayerController: _controller,
    );
  }

  @override
  void dispose() {
    flickManager.dispose();
    // fp.setVideo(false);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    print("***************************************************");
    fp.addWatched(widget.movieId, _controller.value.position.inSeconds);
    print(_controller.value.position.inSeconds);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    fp = Provider.of<FavouritesProvider>(context, listen: false);
    return Container(
      child: FlickVideoPlayer(
        flickManager: flickManager,
        flickVideoWithControls: FlickVideoWithControls(
          controls: FlickLandscapeControls(),
          videoFit: BoxFit.contain,
        ),
        preferredDeviceOrientation: [
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ],
        systemUIOverlay: [],
      ),
    );
  }
}
