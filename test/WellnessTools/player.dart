import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubePlayerPage extends StatefulWidget {
  final int controller;
  final Function setBool;
  const YoutubePlayerPage({
    Key? key,
    required this.setBool,
    required this.controller,
  }) : super(key: key);
  @override
  _YoutubePlayerPageState createState() => _YoutubePlayerPageState();
}

class _YoutubePlayerPageState extends State<YoutubePlayerPage> {
  @override
  @override
  Widget build(BuildContext context) {
    return Container(child: Text(widget.controller.toString()));
  }
}
