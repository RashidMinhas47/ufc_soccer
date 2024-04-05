import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VideoListTiles extends StatelessWidget {
  const VideoListTiles({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      itemCount: 10, // Example count, replace with your actual count
      itemBuilder: (context, index) {
        return Card(
          elevation: 0,
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          shape: Border.all(color: Colors.grey), // Add border
          child: ListTile(
            minVerticalPadding: 0,
            contentPadding:
                EdgeInsets.all(0), // Remove ListTile's default padding
            leading: Container(
              width: 100,
              height: 200,
              decoration: BoxDecoration(
                color: const Color.fromARGB(
                    255, 219, 219, 219), // Example background color
                image: DecorationImage(
                  image: AssetImage(
                      'your_image_path_here'), // Add your image path here
                  fit: BoxFit.cover,
                ),
              ),
            ),
            title: Text(
              "Video $index",
              style: GoogleFonts.poppins(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              "Game Date",
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        );
      },
    );
  }
}
