import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ufc_soccer/providers/auth_providers.dart';
import 'package:ufc_soccer/utils/constants.dart';
import 'package:ufc_soccer/widgets/custom_large_btn.dart';
import 'package:ufc_soccer/widgets/list_tile_with_border.dart';
import 'package:ufc_soccer/widgets/players_list_table.dart';

class VoteForNextGame2 extends ConsumerWidget {
  static const String screen = '/VoteForNextGame2';
  const VoteForNextGame2({super.key});

  @override
  Widget build(BuildContext context, ref) {
    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text(
    //       "Next Game",
    //       style: GoogleFonts.inter(
    //         fontWeight: FontWeight.bold,
    //         fontSize: 30,
    //       ),
    //     ),
    //     centerTitle: true,
    //     actions: [
    //       IconButton(
    //           onPressed: () {
    //             ref.read(signInProvider).signOutUser(context);
    //           },
    //           icon: const Icon(Icons.settings))
    //     ],
    //   ),
    //   body:
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: Column(
          children: [
            NextGameDetailTile(
              date: 'not define yer', //TODO: latter will come
              time: 'not define yer', //TODO: latter will come
              spots: 'not define yer', //TODO: latter will come
            ),
            const PlayersListTable(
              gameTitle: '',
              playerNames: ['hell', 'weel', 'jell'],
            ),
          ],
        ),
      ),
    );
    // );
  }
}
