import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ufc_soccer/providers/game_info_providers.dart';
import 'package:ufc_soccer/providers/text_controllers.dart';
import 'package:ufc_soccer/screens/admin/setup_game.dart';
import 'package:ufc_soccer/utils/button_styles.dart';
import 'package:ufc_soccer/utils/constants.dart';
import 'package:ufc_soccer/utils/image_urls.dart';
import 'package:ufc_soccer/widgets/custom_drop_down_btn.dart';
import 'package:ufc_soccer/widgets/custom_large_btn.dart';
import 'package:ufc_soccer/widgets/custom_switch_btn.dart';
import 'package:ufc_soccer/widgets/date_time_buttons.dart';
import 'package:ufc_soccer/widgets/game_video_player.dart';
import 'package:ufc_soccer/widgets/score_input_widget.dart';
import 'package:ufc_soccer/widgets/text_field_with_border.dart';

import '../../widgets/app_bars.dart';

class UpdatePlayerStats extends ConsumerWidget {
  static const String screen = "/UpdatePlayerStats";

  const UpdatePlayerStats({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final size = MediaQuery.of(context).size;
    final gameInfoState = ref.watch(gameInfoProvider);
    final urlCtr = ref.watch(urlCtrProvider);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBars.appBar("Game Admin", "Update Player Stats"),
      body: Padding(
        padding: kPadd20,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const CustomDDButton(hintText: 'Select Game'),
            const CustomDDButton(
              hintText: "Team Played",
            ),
            ScoreInputWidget(
              label: 'Goals Scored This Game',
              ctrText: gameInfoState.goalsCurrentGame.toString(),
              incrementTap: () => gameInfoState.goalsCurrentGameAdd(),
              decrementTap: () => gameInfoState.goalsCurrentGameRemove(),
            ),
            TextFeildWithBorder(
              controller: urlCtr,
              hintText: 'Enter Highlight YouTube URL',
            ),
            OutlinedButton(
              onPressed: () {},
              style: ButtonStyles.smallOutlineStyle(),
              child: Text(
                "Add",
                style: GoogleFonts.poppins(color: kPrimaryColor),
              ),
            ),
            buildLinkTiles("First Link"),
            buildLinkTiles("Second Link"),
            buildLinkTiles("Third Link"),
            LargeFlatButton(
              onPressed: () {},
              size: size,
              fontColor: kPrimaryColor,
              label: 'Update Player Stats',
              backgroundColor: Colors.white.withOpacity(0),
            ),
          ],
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
