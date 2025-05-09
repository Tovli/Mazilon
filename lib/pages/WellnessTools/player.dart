import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mazilon/AnalyticsService.dart';
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
  bool? _isPlaying;

  @override
  void initState() {
    super.initState();

    controller = YoutubePlayerController(
      initialVideoId: widget.videoData['videoId']?[0] ?? '',
      flags: YoutubePlayerFlags(autoPlay: false),
    );

    listener = () {
      widget.onFullScreenChanged(controller.value.isFullScreen);
      _trackIsPlaying();
    };
    controller.addListener(listener);
  }

  void _trackIsPlaying() {
    if (_isPlaying != controller.value.isPlaying) {
      _isPlaying = controller.value.isPlaying;
      _logEvent(
          _isPlaying!, controller.metadata.title, controller.metadata.videoId);
    }
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

  void _logEvent(bool isPlaying, title, String url) {
    AnalyticsService mixPanelService = GetIt.instance<AnalyticsService>();
    print("logging");
    if (isPlaying) {
      mixPanelService
          .trackEvent("Video unpaused", {"title": title, "url": url});
    } else {
      mixPanelService.trackEvent("Video paused", {"title": title, "url": url});
    }
  }

  @override
  Widget build(BuildContext context) {
    print(controller.metadata.videoId);
    return Container(
      child: YoutubePlayer(
        controller: controller,
        showVideoProgressIndicator: true,
        onReady: () {
          print('Player is ready.');
        },
      ),
    );
  }
}
