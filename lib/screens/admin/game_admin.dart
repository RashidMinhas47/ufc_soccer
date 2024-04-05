import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ufc_soccer/providers/admin_provider.dart';
import 'package:ufc_soccer/screens/admin/game_info.dart';
import 'package:ufc_soccer/screens/admin/manage_app.dart';
import 'package:ufc_soccer/screens/admin/setup_game.dart';
import 'package:ufc_soccer/screens/admin/update_player_stats.dart';
import 'package:ufc_soccer/screens/profile_screens/edit_profile_screen.dart';
import 'package:ufc_soccer/utils/constants.dart';
import 'package:ufc_soccer/utils/firebase_const.dart';
import 'package:ufc_soccer/widgets/custom_large_btn.dart';

class GameAdmin extends ConsumerWidget {
  static const String screen = '/GameAdmin';
  const GameAdmin({super.key});
  // List<Future> onPresseds(BuildContext context) {
  //   return [
  //     Navigator.pushNamed(context, GameSetupScreen.screen),
  //     Navigator.pushNamed(context, GameInfoScreen.screen),
  //     Navigator.pushNamed(context, UpdatePlayerStats.screen),
  //     Navigator.pushNamed(context, GameSetupScreen.screen),
  //   ];
  // }

  @override
  Widget build(BuildContext context, ref) {
    // List<Future> onTaps = [
    //   Navigator.pushNamed(context, GameSetupScreen.screen),
    //   Navigator.pushNamed(context, GameInfoScreen.screen),
    //   Navigator.pushNamed(context, UpdatePlayerStats.screen),
    //   Navigator.pushNamed(context, GameSetupScreen.screen),
    // ];
    final size = MediaQuery.of(context).size;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            "Game Admin",
            style: GoogleFonts.inter(
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int index = 0; index < adminButtons.length; index++)
                  LargeFlatButton(
                    paddH: 10,
                    paddV: 20,
                    backgroundColor: kWhiteColor.withOpacity(0.0),
                    onPressed: () {
                      if (index == 0) {
                        Navigator.pushNamed(context, GameSetupScreen.screen);
                      } else if (index == 1) {
                        Navigator.pushNamed(context, GameInfoScreen.screen);
                      } else if (index == 2) {
                        Navigator.pushNamed(context, UpdatePlayerStats.screen);
                      } else if (index == 3) {
                        Navigator.pushNamed(context, ManageAppSettings.screen);
                      }
                    },
                    size: size,
                    label: adminButtons[index][TITLE],
                    fontColor: kBlackColor,
                  )
              ],
            ),
          ),
        ));
  }
}

List<Map<String, dynamic>> adminButtons = [
  {
    TITLE: 'Setup Match',
    ONPRESSED: (BuildContext context) =>
        Navigator.pushNamed(context, GameSetupScreen.screen),
  },
  {
    TITLE: 'Game Info',
    ONPRESSED: (BuildContext context) =>
        Navigator.pushNamed(context, GameInfoScreen.screen),
  },
  {
    TITLE: 'Update Player Stats',
    ONPRESSED: (BuildContext context) =>
        Navigator.pushNamed(context, UpdatePlayerStats.screen),
  },
  {
    TITLE: 'Manage App Settings',
    ONPRESSED: (BuildContext context) =>
        Navigator.pushNamed(context, UpdatePlayerStats.screen),
  }
];
