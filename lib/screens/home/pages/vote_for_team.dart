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
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ufc_soccer/models/game_model.dart';
import 'package:ufc_soccer/providers/auth_providers.dart';
import 'package:ufc_soccer/providers/home_screen_porvider.dart';
import 'package:ufc_soccer/providers/players_list_provider.dart';
import 'package:ufc_soccer/providers/setup_game_provider.dart';
import 'package:ufc_soccer/utils/constants.dart';
import 'package:ufc_soccer/utils/firebase_const.dart';
import 'package:ufc_soccer/widgets/custom_large_btn.dart';
import 'package:ufc_soccer/widgets/list_tile_with_border.dart';
import 'package:ufc_soccer/widgets/players_list_table.dart';

class VoteForNextGame extends ConsumerWidget {
  static const String screen = '/VoteForNextGame';
  const VoteForNextGame({Key? key, required this.game}) : super(key: key);
  final GameModel game;

  @override
  Widget build(BuildContext context, ref) {
    final gamePro = ref.watch(setupGameProvider);
    // final countdownTimerProvider = StateProvider<int>((ref) {
    //   // Set the initial countdown time based on game.remixTime in hours
    //   return game.timeCountdown * 3600;
    // });

    Timer? _timer;

    // void startCountdownTimer() {
    //   _timer = Timer.periodic(Duration(seconds: 1), (timer) {
    //     final remainingTime = ref.read(countdownTimerProvider.notifier).state;
    //     if (remainingTime > 0) {
    //       ref.read(countdownTimerProvider.notifier).state = remainingTime - 1;
    //       // Update the countdown timer value in Firestore for this game
    //       FirebaseFirestore.instance
    //           .collection(GAMES)
    //           .doc(game.id) // Assuming game.id is the document ID of the game
    //           .update({VOTETIMER: remainingTime - 1});
    //     } else {
    //       timer.cancel();
    //     }
    //   });
    // }

    // Start the countdown timer when the widget is built
    // startCountdownTimer();

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
                // final countdownTime =
                //     ref.watch(countdownTimerProvider.notifier).state;
                // final hours = countdownTime ~/ 3600;
                // final minutes = (countdownTime % 3600) ~/ 60;
                // final seconds = countdownTime % 60;
                return StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection(GAMES)
                      .doc(game.id)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      // Calculate elapsed time since game setup
                      final setupStartTime = snapshot.data!.get(VOTETIMER);
                      final currentTime = DateTime.now();
                      final elapsedDuration =
                          currentTime.difference(setupStartTime.toDate());

                      // Calculate remaining time for setup
                      final setupDuration = Duration(minutes: 0);

                      final remainingDuration = setupDuration - elapsedDuration;
                      FirebaseFirestore.instance
                          .collection(GAMES)
                          .doc(game.id)
                          .update({REMAININGTIME: remainingDuration.inSeconds});
                      return CountdownTimerWidget(
                        remainingTimeInSeconds: remainingDuration
                            .inSeconds, // Pass your remaining time in seconds here
                      );
                      // Text(
                      //     'Remaining Time: ${remainingDuration.inMinutes} minutes');
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                );

                //  Text(
                //   'Remix Team: not defiend yet',
                //   style: GoogleFonts.poppins(fontSize: 20),
                // );
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LargeFlatButton(
                  onPressed: () {
                    gamePro.voteForYes(game.id);
                  },
                  size: const Size(120, 60),
                  fontColor: kPrimaryColor,
                  label: "Yes",
                  backgroundColor: Colors.transparent,
                ),
                const SizedBox(width: 20),
                LargeFlatButton(
                  onPressed: () {
                    gamePro.voteForNo(game.id);
                  },
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

class CountdownTimerWidget extends StatefulWidget {
  final int remainingTimeInSeconds;

  const CountdownTimerWidget({super.key, required this.remainingTimeInSeconds});

  @override
  // ignore: library_private_types_in_public_api
  _CountdownTimerWidgetState createState() => _CountdownTimerWidgetState();
}

class _CountdownTimerWidgetState extends State<CountdownTimerWidget> {
  late Timer _timer;
  late Duration _remainingTime;

  @override
  void initState() {
    super.initState();
    _remainingTime = Duration(seconds: widget.remainingTimeInSeconds);
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    int hours = _remainingTime.inHours;
    int minutes = _remainingTime.inMinutes.remainder(60);
    int seconds = _remainingTime.inSeconds.remainder(60);

    return Text(
      'Remaining Time: ${hours < 1 ? "" : hours < 10 ? "0$hours:" : "$hours:"}${_formatTime(minutes)}:${_formatTime(seconds)}',
      style: const TextStyle(fontSize: 20),
    );
  }

  String _formatTime(int time) {
    return time < 10 ? '0$time' : '$time';
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _remainingTime = _remainingTime - const Duration(seconds: 1);
        if (_remainingTime <= const Duration(seconds: 0)) {
          _timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
