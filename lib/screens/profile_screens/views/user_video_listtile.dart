// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class UserVideoListTile extends StatelessWidget {
  final String videoUrl;
  final String videoNumber;
  final String selectedGame;
  final VoidCallback onTap;

  const UserVideoListTile({
    super.key,
    required this.videoUrl,
    required this.videoNumber,
    required this.selectedGame,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: videoUrl != null || videoUrl.isNotEmpty
          ? Image.network(
              getThumbnailUrl(videoUrl),
              height: 120,
            )
          : const SizedBox
              .shrink(), // Show thumbnail only if video URL is not empty
      title: Text(
        videoNumber,
        style: GoogleFonts.poppins(fontSize: 18),
      ),
      subtitle: Text(
        selectedGame,
        style: GoogleFonts.poppins(fontSize: 14),
      ),
      onTap: onTap,
    );
  }

  String getThumbnailUrl(String videoUrl) {
    final videoId = YoutubePlayer.convertUrlToId(videoUrl);
    return 'https://img.youtube.com/vi/$videoId/mqdefault.jpg';
  }
}
