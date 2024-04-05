// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:ufc_soccer/models/game_model.dart';
// import 'package:ufc_soccer/providers/auth_providers.dart';
// import 'package:ufc_soccer/providers/home_screen_porvider.dart';
// import 'package:ufc_soccer/providers/players_list_provider.dart';
// import 'package:ufc_soccer/providers/setup_game_provider.dart';
// import 'package:ufc_soccer/utils/constants.dart';
// import 'package:ufc_soccer/widgets/custom_large_btn.dart';
// import 'package:ufc_soccer/widgets/list_tile_with_border.dart';
// import 'package:ufc_soccer/widgets/players_list_table.dart';

// class VoteForNextGame extends ConsumerWidget {
//   static const String screen = '/VoteForNextGame';
//   const VoteForNextGame({super.key, required this.game});
//   final GameModel game;

//   @override
//   Widget build(BuildContext context, ref) {
//     return
//         // Scaffold(
//         //   appBar: AppBar(
//         //     title: Text(
//         //       "Next Game",
//         //       style: GoogleFonts.inter(
//         //         fontWeight: FontWeight.bold,
//         //         fontSize: 30,
//         //       ),
//         //     ),
//         //     centerTitle: true,
//         //     actions: [
//         //       IconButton(
//         //           onPressed: () {
//         //             ref.read(signInProvider).signOutUser(context);
//         //           },
//         //           icon: const Icon(Icons.settings))
//         //     ],
//         //   ),
//         //   body:
//         Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "Next Game",
//           style: GoogleFonts.inter(
//             fontWeight: FontWeight.bold,
//             fontSize: 30,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               NextGameDetailTile(
//                 time: game.time,
//                 date: game.date,
//                 spots: game.maxPlayer.toString(),
//               ),
//               PlayersListTable(
//                 playerNames: game.joinedPlayerNames,
//               ),
//               // const PlayersListTable(),
//               Text(
//                 'Remix Team {Vote countdown time}', //Todo: here the total time of the Remix Team Will be available for voters
//                 style: GoogleFonts.poppins(fontSize: 20),
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   LargeFlatButton(
//                       onPressed: () {},
//                       size: const Size(120, 60),
//                       fontColor: kPrimaryColor,
//                       label: "Yes",
//                       backgroundColor: Colors.transparent),
//                   const SizedBox(width: 20),
//                   LargeFlatButton(
//                       onPressed: () {},
//                       size: const Size(120, 60),
//                       fontColor: kPrimaryColor,
//                       label: "No",
//                       backgroundColor: Colors.transparent),
//                 ],
//               )
//             ],
//           )

//           // Consumer(builder: (context, ref, child) {
//           //   final gamePro = ref.watch(gameListProvider);
//           //   final playerList = ref.watch(playerListProvider);

//           //   return gamePro.when(
//           //       data: (gameList) {
//           //         return ListView.builder(
//           //             itemCount: gameList.length,
//           //             itemBuilder: (context, index) {
//           //               return Column(
//           //                 mainAxisAlignment: MainAxisAlignment.start,
//           //                 children: [
//           //                   NextGameDetailTile(
//           //                     time: gameList[index].time,
//           //                     date: gameList[index].date,
//           //                     spots: gameList[index].maxPlayer.toString(),
//           //                   ),
//           //                   PlayersListTable(
//           //                     playerNames: playerList.value!,
//           //                   ),
//           //                   // const PlayersListTable(),
//           //                   Text(
//           //                     'Remix Team {Vote countdown time}', //Todo: here the total time of the Remix Team Will be available for voters
//           //                     style: GoogleFonts.poppins(fontSize: 20),
//           //                   ),
//           //                   Row(
//           //                     mainAxisAlignment: MainAxisAlignment.center,
//           //                     children: [
//           //                       LargeFlatButton(
//           //                           onPressed: () {},
//           //                           size: const Size(120, 60),
//           //                           fontColor: kPrimaryColor,
//           //                           label: "Yes",
//           //                           backgroundColor: Colors.transparent),
//           //                       const SizedBox(width: 20),
//           //                       LargeFlatButton(
//           //                           onPressed: () {},
//           //                           size: const Size(120, 60),
//           //                           fontColor: kPrimaryColor,
//           //                           label: "No",
//           //                           backgroundColor: Colors.transparent),
//           //                     ],
//           //                   )
//           //                 ],
//           //               );
//           //             });
//           //       },
//           //       loading: () => Center(child: CircularProgressIndicator()),
//           //       error: (error, stackTrace) =>
//           //           Center(child: Text('Error: $error')));
//           // }),

//           // ),
//           ),
//     );
//   }
// }

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ufc_soccer/models/game_model.dart';
import 'package:ufc_soccer/providers/auth_providers.dart';
import 'package:ufc_soccer/providers/home_screen_porvider.dart';
import 'package:ufc_soccer/providers/players_list_provider.dart';
import 'package:ufc_soccer/providers/setup_game_provider.dart';
import 'package:ufc_soccer/utils/constants.dart';
import 'package:ufc_soccer/widgets/custom_large_btn.dart';
import 'package:ufc_soccer/widgets/list_tile_with_border.dart';
import 'package:ufc_soccer/widgets/players_list_table.dart';

class VoteForNextGame extends ConsumerWidget {
  static const String screen = '/VoteForNextGame';
  const VoteForNextGame({Key? key, required this.game}) : super(key: key);
  final GameModel game;

  @override
  Widget build(BuildContext context, ref) {
    final countdownTimerProvider = StateProvider<int>((ref) {
      // Set the initial countdown time based on game.remixTime in hours
      return game.timeCountdown * 3600;
    });

    Timer? _timer;

    void startCountdownTimer() {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        final remainingTime = ref.read(countdownTimerProvider.notifier).state;
        if (remainingTime > 0) {
          ref.read(countdownTimerProvider.notifier).state = remainingTime - 1;
        } else {
          timer.cancel();
        }
      });
    }

    // Start the countdown timer when the widget is built
    startCountdownTimer();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Next Game",
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            NextGameDetailTile(
              time: game.time,
              date: game.date,
              spots: game.maxPlayer.toString(),
            ),
            PlayersListTable(
              playerNames: game.joinedPlayerNames,
            ),
            Consumer(
              builder: (context, ref, _) {
                final countdownTime =
                    ref.watch(countdownTimerProvider.notifier).state;
                final hours = countdownTime ~/ 3600;
                final minutes = (countdownTime % 3600) ~/ 60;
                final seconds = countdownTime % 60;
                return Text(
                  'Remix Team: $hours:$minutes:$seconds',
                  style: GoogleFonts.poppins(fontSize: 20),
                );
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LargeFlatButton(
                  onPressed: () {},
                  size: const Size(120, 60),
                  fontColor: kPrimaryColor,
                  label: "Yes",
                  backgroundColor: Colors.transparent,
                ),
                const SizedBox(width: 20),
                LargeFlatButton(
                  onPressed: () {},
                  size: const Size(120, 60),
                  fontColor: kPrimaryColor,
                  label: "No",
                  backgroundColor: Colors.transparent,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
