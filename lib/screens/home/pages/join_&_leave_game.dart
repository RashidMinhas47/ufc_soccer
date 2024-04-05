import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ufc_soccer/providers/auth_providers.dart';
import 'package:ufc_soccer/providers/home_screen_porvider.dart';
import 'package:ufc_soccer/providers/joining_&_leaving_provider.dart';
import 'package:ufc_soccer/providers/text_controllers.dart';
import 'package:ufc_soccer/providers/user_data.dart';
import 'package:ufc_soccer/screens/home/pages/vote_for_team.dart';
import 'package:ufc_soccer/utils/constants.dart';
import 'package:ufc_soccer/utils/firebase_const.dart';
import 'package:ufc_soccer/widgets/custom_large_btn.dart';

class JoinGameScreen extends ConsumerWidget {
  static const String screen = '/JoinGameScreen';
  const JoinGameScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Consumer(
        builder: (context, ref, child) {
          final gameList =
              ref.watch(gameListProvider); // Access the gameListProvider
          final gamePro = ref.watch(gameJoinProvider);
          return gameList.when(
            data: (games) {
              return ListView.builder(
                itemCount: games.length,
                itemBuilder: (context, index) {
                  final game = games[index];
                  final userUid = ref.watch(userDataProvider).userUid;
                  final userName = ref.watch(userDataProvider).fullName;
                  final joinGameLabel =
                      List<String>.generate(games.length, (i) {
                    return "Join Game";
                  });
                  print(joinGameLabel);
                  final leaveGameLabel =
                      List<String>.generate(games.length, (i) {
                    return "Leave Game";
                  });

                  // Check if the user's UID is already in the JOINEDPLAYERS list
                  // Check if the user's UID is already in the joinedPlayers list for each game
                  List<bool> isJoinedList = [];
                  for (final game in games) {
                    final isJoined = game.joinedPlayerUids.contains(userUid);
                    isJoinedList.add(isJoined);
                    // gamePro.addJoinedList(isJoined);
                    print(isJoined);
                  }
                  return Column(
                    children: [
                      ListTile(
                        leading: const CircleAvatar(
                          child: Icon(Icons.person),
                        ),
                        title: Text(game.name,
                            style: GoogleFonts.poppins(
                                fontSize: 16, fontWeight: FontWeight.w700)),
                      ),
                      AspectRatio(
                        aspectRatio: 1,
                        child: Container(
                          decoration: const BoxDecoration(color: kGrayColor),
                          child: const Icon(
                            Icons.image,
                            size: 140,
                          ),
                        ),
                      ),
                      Text(
                        "Sign Up For a Game",
                        style: GoogleFonts.poppins(
                            fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                      Text("Date: ${game.date} Time: ${game.time}"),
                      Text("Available Spots: ${game.maxPlayer.toString()}"),
                      game.maxPlayer == 0
                          ? LargeFlatButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            VoteForNextGame(game: game)));
                              },
                              size: Size(size.width * 0.7, 70),
                              fontColor: kPrimaryColor,
                              label: "Game Details",
                              backgroundColor: kWhiteColor.withOpacity(0))
                          : LargeFlatButton(
                              onPressed: () async {
                                try {
                                  final QuerySnapshot querySnapshot =
                                      await FirebaseFirestore.instance
                                          .collection(GAMES)
                                          .get();

                                  // Loop through the documents in the result set
                                  for (QueryDocumentSnapshot docSnapshot
                                      in querySnapshot.docs) {
                                    // Access the document ID using the id property
                                    final newId = docSnapshot.id;
                                    gamePro.addGameIds(newId);
                                    // gamePro.gameId[index] = docSnapshot.id;

                                    print('Game ID: ${gamePro.gameId}');
                                  }
                                  final _firestore = FirebaseFirestore.instance;

                                  if (isJoinedList[index]) {
                                    // If the user has already joined, perform leave game functionality
                                    await _firestore
                                        .collection(GAMES)
                                        .doc(gamePro.gameId[index])
                                        .update({
                                      JOINEDPLAYERS:
                                          FieldValue.arrayRemove([userUid]),
                                      JOINEDPLAYERNAMES:
                                          FieldValue.arrayRemove([userName]),
                                      MAXPLAYER: game.maxPlayer + 1
                                    });
                                  } else {
                                    // If the user has not joined, perform join game functionality
                                    await _firestore
                                        .collection(GAMES)
                                        .doc(gamePro.gameId[index])
                                        .update({
                                      JOINEDPLAYERS:
                                          FieldValue.arrayUnion([userUid]),
                                      JOINEDPLAYERNAMES:
                                          FieldValue.arrayUnion([userName]),
                                      MAXPLAYER: game.maxPlayer - 1
                                    });
                                  }
                                } catch (error) {
                                  print('Error joining/leaving game: $error');
                                }
                              },
                              size: const Size(200, 100),
                              fontColor: kPrimaryColor,
                              label: isJoinedList[index]
                                  ? leaveGameLabel[index]
                                  : joinGameLabel[index],
                              backgroundColor: Colors.white.withOpacity(0),
                            ),
                    ],
                  );
                },
              );
            },
            loading: () => progressWidget,
            error: (error, stackTrace) => Center(child: Text('Error: $error')),
          );
        },
      ),
    );
  }
}

const progressWidget = Center(child: CircularProgressIndicator());


// class LeaveGameScreen extends ConsumerWidget {
//   static const String screen = '/LeaveGameScreen';
//   const LeaveGameScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final userData = ref.watch(userDataProvider);
//     final gameList = ref.watch(gameListProvider);

//     // Filter the game list to show only the joined game
//     final joinedGame = gameList.value?.firstWhere(
//       (game) => game.joinedPlayers.contains(userData.fullName),
//       orElse: () {
//         throw Error();
//       },
//     );

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "Joined Game",
//           style: GoogleFonts.inter(
//             fontWeight: FontWeight.bold,
//             fontSize: 30,
//           ),
//         ),
//         centerTitle: true,
//         actions: [
//           IconButton(
//             onPressed: () {
//               ref.read(signInProvider).signOutUser(context);
//             },
//             icon: const Icon(Icons.settings),
//           )
//         ],
//       ),
//       body: joinedGame != null
//           ? Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20.0),
//               child: Column(
//                 children: [
//                   AspectRatio(
//                     aspectRatio: 1,
//                     child: Container(
//                       decoration: BoxDecoration(color: kGrayColor),
//                       child: Icon(
//                         Icons.image,
//                         size: 140,
//                       ),
//                     ),
//                   ),
//                   Text(
//                     "Sign Up For a Game",
//                     style: GoogleFonts.poppins(
//                       fontSize: 18,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                   Text(
//                     "Date: ${joinedGame.date} Time: ${joinedGame.time}",
//                   ),
//                   Text(
//                     "Available Spots: ${joinedGame.maxPlayer.toString()}",
//                   ),
//                   LargeFlatButton(
//                     onPressed: () {
//                       // Add leave game functionality here
//                     },
//                     size: const Size(200, 100),
//                     fontColor: kPrimaryColor,
//                     label: 'Leave Game',
//                     backgroundColor: Colors.white.withOpacity(0),
//                   ),
//                 ],
//               ),
//             )
//           : Center(
//               child: Text(
//                 'You have not joined any game.',
//                 style: TextStyle(fontSize: 18),
//               ),
//             ),
//     );
//   }
// }
