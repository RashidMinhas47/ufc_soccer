// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class UserVideoListTile extends StatelessWidget {
  final String videoUrl;
  final String videoNumber;
  final String selectedGame;

  UserVideoListTile({
    Key? key,
    required this.videoUrl,
    required this.videoNumber,
    required this.selectedGame,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: videoUrl.isNotEmpty
          ? Image.network(getThumbnailUrl(videoUrl))
          : Container(), // Show thumbnail only if video URL is not empty
      title: Text('Video $videoNumber'),
      subtitle: Text(selectedGame),
      onTap: () {
        if (videoUrl.isNotEmpty) {
          // Handle video playback or navigation to video screen
          // Example:
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => VideoPlayerScreen(videoUrl),
          //   ),
          // );
        }
      },
    );
  }

  String getThumbnailUrl(String videoUrl) {
    final videoId = YoutubePlayer.convertUrlToId(videoUrl);
    return 'https://img.youtube.com/vi/$videoId/mqdefault.jpg';
  }
}
