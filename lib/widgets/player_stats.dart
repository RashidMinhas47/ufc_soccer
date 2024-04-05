import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ufc_soccer/utils/image_urls.dart';

class PlayerStatsCard extends StatelessWidget {
  const PlayerStatsCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          ListTile(
            leading: SvgPicture.asset(
              AppSvg.footballIcon,
              height: 14,
              color: Colors.black,
            ),
            title: Text(
              "Total Games Played [Game Number]", //todo:here will add backend latter
              style: GoogleFonts.poppins(
                  fontSize: 14, fontWeight: FontWeight.normal),
            ),
          ),
          divider20,
          ListTile(
            leading: Icon(
              Icons.timer,
              size: 16,
              color: Colors.black,
            ),
            title: Text(
              "Total Play Time [Game Time]", //todo:here will add backend latter
              style: GoogleFonts.poppins(
                  fontSize: 14, fontWeight: FontWeight.normal),
            ),
          ),
          divider20,
          ListTile(
            leading: Icon(
              Icons.donut_small,
              size: 16,
              color: Colors.black,
            ),
            title: Text(
              "Total Goals Scored [Game Count]", //todo:here will add backend latter
              style: GoogleFonts.poppins(
                  fontSize: 14, fontWeight: FontWeight.normal),
            ),
          ),
          divider20,
          ListTile(
            leading: Icon(
              Icons.donut_small,
              size: 16,
              color: Colors.black,
            ),
            title: Text(
              "Average Goals Per Game [games/goals]", //todo:here will add backend latter
              style: GoogleFonts.poppins(
                  fontSize: 14, fontWeight: FontWeight.normal),
            ),
          ),
          divider20,
        ],
      ),
    );
  }
}

const divider20 = Divider(
  color: Color.fromARGB(255, 226, 224, 224),
  thickness: 1.4,
  endIndent: 20,
  indent: 20,
);
