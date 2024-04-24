import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ufc_soccer/providers/game_info_providers.dart';
import 'package:ufc_soccer/providers/players_list_provider.dart';
import 'package:ufc_soccer/screens/home/pages/join_&_leave_game.dart';
import 'package:ufc_soccer/utils/constants.dart';

class PlayersListTable extends StatelessWidget {
  const PlayersListTable(
      {super.key, required this.playerNames, required this.gameTitle});
  final List<String> playerNames;
  final String gameTitle;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        height: 280,
        child: Consumer(builder: (context, ref, child) {
          return FutureBuilder(
              future: ref
                  .watch(gameInfoProvider)
                  .fetchSelectedPlayersForList(gameTitle),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return progressWidget;
                } else if (snapshot.hasError) {
                  return Text("Something went wrong");
                } else if (snapshot.hasData) {
                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.length, // Example number of rows
                    itemBuilder: (context, index) => Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Divider above row
                        // ListTile(
                        // contentPadding: const EdgeInsets.symmetric(vertical: 0),
                        // title:
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(1.0),
                              margin: const EdgeInsets.symmetric(vertical: 2.0),
                              decoration:
                                  const BoxDecoration(color: kPrimaryColor),
                              child: const Icon(
                                Icons.check,
                                size: 8,
                                color: kWhiteColor,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                snapshot.data![index],
                                // playerNames[index],
                                // "playersPro.teamAPlayers[index]", // Example team name
                                style: GoogleFonts.poppins(fontSize: 13),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              alignment: Alignment.centerRight,
                              child: Text(
                                "Player $index", // Example team name
                                style: GoogleFonts.poppins(fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                        Divider(
                            indent: 70,
                            endIndent: 70,
                            height: 4,
                            color: Colors.grey.withOpacity(0.2)),
                        // ),
                      ],
                    ),
                  );
                } else {
                  return Text("You have encounter error");
                }
              });
        }));
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:ufc_soccer/providers/players_list_provider.dart';

// class PlayersListTable extends ConsumerWidget {
//   const PlayersListTable({super.key});

//   @override
//   Widget build(BuildContext context, ref) {
//     // Access the playerListProvider to retrieve the list of player names
//     final playerListAsync = ref.watch(playerListProvider);

//     return  Container(
//         height: 300,
//         width: 300,
//         child: playerListAsync.when(
//           // Handle the different states of the asynchronous provider
//           data: (playerNames) {
//             if (playerNames.isNotEmpty) {
//               // If player names are available, display them in a ListView
//               return ListView.builder(
//                 itemCount: playerNames.length,
//                 itemBuilder: (context, index) {
//                   final playerName = playerNames[index];
//                   return ListTile(
//                     title: Text(playerName),
//                   );
//                 },
//               );
//             } else {
//               // If no player names are available, display a message
//               return Center(
//                 child: Text('No player names available.'),
//               );
//             }
//           },
//           loading: () => Center(child: CircularProgressIndicator()),
//           error: (error, stackTrace) => Center(child: Text('Error: $error')),
      
//       ),
//     );
//   }
// }
