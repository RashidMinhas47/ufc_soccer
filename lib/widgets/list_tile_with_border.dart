import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ufc_soccer/providers/home_screen_porvider.dart';
import 'package:ufc_soccer/screens/home/pages/join_&_leave_game.dart';
import 'package:ufc_soccer/utils/image_urls.dart';

class NextGameDetailTile extends StatelessWidget {
  const NextGameDetailTile(
      {super.key, required this.time, required this.date, required this.spots});
  final String time;
  final String date;
  final String spots;
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey, // Border color
            width: 1.0, // Border width
          ),
          borderRadius: BorderRadius.circular(8), // Border radius
        ),
        child: ListTile(
          leading: Container(
            width: 50, // Adjust width as needed
            height: 50, // Adjust height as needed
            decoration: const BoxDecoration(
              shape: BoxShape.rectangle,
              image: DecorationImage(
                image: AssetImage(
                    AppImages.appIcon), // Replace with your image icon
                fit: BoxFit.cover,
              ),
            ),
          ),
          title: Text(
            'Next Game',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          subtitle: Text.rich(
            TextSpan(
              text: 'Date: $date',
              children: [
                TextSpan(
                  text: 'Time $time', //TOdo: Replace with actual next game date
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const TextSpan(text: '\nSpots available: '),
                TextSpan(
                  text: spots, //Todo: Replace with actual spots available
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
