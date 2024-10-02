import 'package:flutter/material.dart';
import 'package:mazilon/pages/WellnessTools/VideoPlayerInheritedWidget.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayerPage extends StatefulWidget {
  final Function(bool isFullScreen) onFullScreenChanged;
  final Map<String, List<String>> videoData;
  const VideoPlayerPage(
      {Key? key, required this.onFullScreenChanged, required this.videoData})
      : super(key: key);
  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late VoidCallback listener;
  late YoutubePlayerController controller;
  @override
  void initState() {
    super.initState();

    controller = YoutubePlayerController(
      initialVideoId: widget.videoData['videoId']?[0] ?? '',
      flags: YoutubePlayerFlags(autoPlay: false),
    );

    listener = () {
      widget.onFullScreenChanged(controller.value.isFullScreen);
    };
    controller.addListener(listener);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Update the video when the inherited widget provides a new videoId
    final newVideoId = VideoPlayerInheritedWidget.of(context)?.videoId ?? '';
    if (newVideoId != controller.metadata.videoId) {
      controller.load(newVideoId);
    }
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: YoutubePlayer(
      controller: controller,
      showVideoProgressIndicator: true,
      onReady: () {
        print('Player is ready.');
      },
    ));
  }
}
