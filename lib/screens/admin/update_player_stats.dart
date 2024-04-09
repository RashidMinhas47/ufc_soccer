import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ufc_soccer/providers/game_info_providers.dart';
import 'package:ufc_soccer/providers/text_controllers.dart';
import 'package:ufc_soccer/providers/update_player_stats_provider.dart';
import 'package:ufc_soccer/screens/profile_screens/edit_profile_screen.dart';
import 'package:ufc_soccer/utils/button_styles.dart';
import 'package:ufc_soccer/utils/constants.dart';
import 'package:ufc_soccer/utils/firebase_const.dart';
import 'package:ufc_soccer/utils/image_urls.dart';
import 'package:ufc_soccer/widgets/custom_drop_down_btn.dart';
import 'package:ufc_soccer/widgets/custom_large_btn.dart';
import 'package:ufc_soccer/widgets/score_input_widget.dart';
import 'package:ufc_soccer/widgets/text_field_with_border.dart';

import '../../widgets/app_bars.dart';

class UpdatePlayerStats extends ConsumerWidget {
  static const String screen = "/UpdatePlayerStats";

  const UpdatePlayerStats({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final size = MediaQuery.of(context).size;
    final gameInfoPro = ref.watch(gameInfoProvider);
    final urlCtr = ref.watch(urlCtrProvider);
    ref.watch(gameInfoProvider).fetchDropdownItems();
    final uPStatsPro = ref.watch(updatePlayerStatsProvider);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBars.appBar("Game Admin", "Update Player Stats"),
      body: uPStatsPro.isloading
          ? prograssWidget
          : SingleChildScrollView(
              child: Padding(
                padding: kPadd20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    CustomDDButton(
                      hintText: "Select Game",
                      parantValue: gameInfoPro.selectGame,
                      onChanged: (String? newValue) {
                        gameInfoPro.selectedGame(newValue);
                        gameInfoPro.fetchSelectedPlayers(newValue ?? 'Game 1');
                      },
                      items: gameInfoPro.playedGames
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: GoogleFonts.poppins(),
                            overflow: TextOverflow.fade,
                          ),
                        );
                      }).toList(),
                    ),
                    Consumer(builder: (context, ref, child) {
                      // if (gameInfoPro.selectPlayer == null) {
                      //   return SizedBox.shrink();
                      // } else {
                      return CustomDDButton(
                        hintText: "Select Player",
                        parantValue: gameInfoPro.selectPlayer,
                        onChanged: (String? newValue) {
                          gameInfoPro.selectedPlayer(newValue);
                          gameInfoPro.selectedPlayerUid(
                              newValue, gameInfoPro.selectedUids);
                          gameInfoPro
                              .fetchSelectedPlayers(gameInfoPro.selectGame!);
                          ref
                              .watch(updatePlayerStatsProvider)
                              .fetchUserData(gameInfoPro.selectUid!);
                        },
                        items: gameInfoPro.selectedPlayers
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: GoogleFonts.poppins(),
                              overflow: TextOverflow.fade,
                            ),
                          );
                        }).toList(),
                      );
                      // }
                    }),
                    ScoreInputWidget(
                      label: 'Goals Scored This Game',
                      ctrText: gameInfoPro.goalsCurrentGame.toString(),
                      incrementTap: () => gameInfoPro.goalsCurrentGameAdd(),
                      decrementTap: () => gameInfoPro.goalsCurrentGameRemove(),
                    ),
                    TextFeildWithBorder(
                      controller: urlCtr,
                      hintText: 'Enter Highlight YouTube URL',
                    ),
                    OutlinedButton(
                      onPressed: () {
                        uPStatsPro.addVideoUrls(urlCtr.text);
                      },
                      style: ButtonStyles.smallOutlineStyle(),
                      child: Text(
                        "Add",
                        style: GoogleFonts.poppins(color: kPrimaryColor),
                      ),
                    ),
                    for (int i = 0; i < uPStatsPro.videoUrls.length; i++)
                      buildLinkTiles("${i + 1} Link"),
                    LargeFlatButton(
                      onPressed: () {
                        // List<Map<String, dynamic>> userData = [];

                        uPStatsPro.addNewGameData({
                          GAME_TITLE: gameInfoPro.selectGame,
                          GOALS_SCORED: gameInfoPro.goalsCurrentGame,
                          VIDEO_URL: uPStatsPro.videoUrls,
                        }, gameInfoPro.selectUid);
                        uPStatsPro.updatePlayerStats(
                          gameInfoPro.selectUid!,
                          context,
                          totalGames: uPStatsPro.updatedTotalGames,
                          totalGoals: uPStatsPro.updatedTotalGoals,
                          aveGoals: uPStatsPro.updateAveGoals(),
                        );
                      },
                      size: size,
                      fontColor: kPrimaryColor,
                      label: 'Update Player Stats',
                      backgroundColor: Colors.white.withOpacity(0),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Column buildLinkTiles(String label) {
    return Column(
      children: [
        ListTile(
          leading: SvgPicture.asset(
            AppSvg.youtubeIcon,
            height: 10,
          ),
          title: Text(
            label,
            style: GoogleFonts.poppins(fontSize: 18),
          ),
        ),
        Divider(
          endIndent: 10,
          indent: 10,
          thickness: 1.4,
          color: Colors.grey.withOpacity(0.3),
        ),
      ],
    );
  }
}
