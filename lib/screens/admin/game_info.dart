import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ufc_soccer/providers/game_info_providers.dart';
import 'package:ufc_soccer/providers/setup_game_provider.dart';
import 'package:ufc_soccer/providers/text_controllers.dart';
import 'package:ufc_soccer/screens/admin/setup_game.dart';
import 'package:ufc_soccer/screens/admin/update_player_stats.dart';
import 'package:ufc_soccer/utils/constants.dart';
import 'package:ufc_soccer/widgets/app_bars.dart';
import 'package:ufc_soccer/widgets/custom_drop_down_btn.dart';
import 'package:ufc_soccer/widgets/custom_large_btn.dart';
import 'package:ufc_soccer/widgets/custom_switch_btn.dart';
import 'package:ufc_soccer/widgets/date_time_buttons.dart';
import 'package:ufc_soccer/widgets/game_video_player.dart';
import 'package:ufc_soccer/widgets/score_input_widget.dart';
import 'package:ufc_soccer/widgets/text_field_with_border.dart';

class GameInfoScreen extends ConsumerWidget {
  static const String screen = "/GameInfoScreen";

  const GameInfoScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final urlCtr = ref.watch(urlCtrProvider);
    final gameInfoPro = ref.watch(gameInfoProvider);
    final size = MediaQuery.of(context).size;
    final setGamePro = ref.watch(setupGameProvider);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBars.appBar("Game Admin", "Game Info"),
      body: Padding(
        padding: kPadd20,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const CustomDDButton(
              hintText: "Select Game",
            ),
            const GameVideoPlayer(),
            TextFeildWithBorder(
                controller: urlCtr, hintText: 'Enter YouTube URL'),
            // SwitchCustomButton(
            //   label: "Release Video Immediately",
            //   onChanged: (value) {
            //     setGamePro.setVotingCondition(value);
            //   },
            //   value: setGamePro.remixVoting,
            // ),
            //todo:
            ScoreInputWidget(
              label: 'Blue Team Score',
              incrementTap: () => gameInfoPro.blueTeamScoreAdd(),
              decrementTap: () => gameInfoPro.blueTeamScoreRemove(),
              ctrText: gameInfoPro.blueTeamScore.toString(),
            ),
            ScoreInputWidget(
              label: 'Red Team Score',
              ctrText: gameInfoPro.redTeamScore.toString(),
              incrementTap: () => gameInfoPro.redTeamScoreAdd(),
              decrementTap: () => gameInfoPro.redTeamScoreRemove(),
            ),
            LargeFlatButton(
                onPressed: () {},
                size: size,
                fontColor: kPrimaryColor,
                label: 'Update Game Info',
                backgroundColor: Colors.white.withOpacity(0))
          ],
        ),
      ),
    );
  }
}
