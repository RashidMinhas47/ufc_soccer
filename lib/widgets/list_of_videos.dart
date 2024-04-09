import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VideoListTiles extends StatelessWidget {
  const VideoListTiles({super.key});

  @override
  Widget build(BuildContext context) {
    // return ListView.builder(
    //   itemCount: userVideos.length,
    //   itemBuilder: (context, index) {
    //     final videoData = userVideos[index];
    //     final videoUrl = videoData['VIDEO_URL'];
    //     final videoNumber =
    //         (index + 1).toString(); // Video number starts from 1
    //     final selectedGame = videoData['SELECTED_GAME'];

    //     return UserVideoListTile(
    //       videoUrl: videoUrl,
    //       videoNumber: videoNumber,
    //       selectedGame: selectedGame,
    //     );
    //   },
    // );

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      itemCount: 10, // Example count, replace with your actual count
      itemBuilder: (context, index) {
        return VideoListTileCustom(
            onTap: () {},
            title: 'title',
            subtitle: 'subtitle',
            imageUrl: 'imageUrl');
      },
    );
  }
}

class VideoListTileCustom extends StatelessWidget {
  const VideoListTileCustom(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.imageUrl,
      required this.onTap});
  final String title;
  final String subtitle;
  final String imageUrl;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      shape: Border.all(color: Colors.grey), // Add border
      child: ListTile(
        onTap: onTap,
        minVerticalPadding: 0,
        contentPadding:
            const EdgeInsets.all(0), // Remove ListTile's default padding
        leading: Container(
          width: 100,
          height: 200,
          decoration: BoxDecoration(
            color: const Color.fromARGB(
                255, 219, 219, 219), // Example background color
            image: DecorationImage(
              image: NetworkImage(imageUrl), // Add your image path here
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
    );
    ;
  }
}
