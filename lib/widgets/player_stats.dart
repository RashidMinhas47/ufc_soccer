import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ufc_soccer/providers/user_data.dart';
import 'package:ufc_soccer/utils/image_urls.dart';

class PlayerStatsCard extends ConsumerWidget {
  const PlayerStatsCard({
    super.key,
  });

  @override
  Widget build(BuildContext context, ref) {
    ref.watch(userDataProvider).fetchUserData();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Consumer(builder: (context, ref, child) {
        final userData = ref.watch(userDataProvider);
        return Column(
          children: [
            ListTile(
              leading: SvgPicture.asset(
                AppSvg.footballIcon,
                height: 14,
                color: Colors.black,
              ),
              title: Text(
                "Total Games Played [${userData.totalGames ?? 0}]", //todo:here will add backend latter
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
                "Total Goals Scored [${userData.totalGoals ?? 0}]", //todo:here will add backend latter
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
                "Average Goals Per Game [${userData.aveGoals ?? 0.0}]", //todo:here will add backend latter
                style: GoogleFonts.poppins(
                    fontSize: 14, fontWeight: FontWeight.normal),
              ),
            ),
            divider20,
          ],
        );
      }),
    );
  }
}

const divider20 = Divider(
  color: Color.fromARGB(255, 226, 224, 224),
  thickness: 1.4,
  endIndent: 20,
  indent: 20,
);
