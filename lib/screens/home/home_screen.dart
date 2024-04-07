import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ufc_soccer/providers/auth_providers.dart';
import 'package:ufc_soccer/providers/home_screen_porvider.dart';
import 'package:ufc_soccer/providers/text_controllers.dart';
import 'package:ufc_soccer/screens/home/pages/join_&_leave_game.dart';
import 'package:ufc_soccer/screens/home/pages/vote_for_team.dart';
import 'package:ufc_soccer/screens/home/pages/vote_route_2.dart';
import 'package:ufc_soccer/screens/home/pages/vote_route_3.dart';
import 'package:ufc_soccer/utils/constants.dart';
import 'package:ufc_soccer/widgets/custom_large_btn.dart';
import 'package:ufc_soccer/widgets/widget_tester.dart';

class NextGameScreen extends StatelessWidget {
  static const String screen = '/NextGameScreen';
  const NextGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> joinLeavePages = [
      JoinGameScreen(),
      // VoteForNextGame(),
      VoteForNextGame2(),
      VoteForNextGame3()
    ];
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
          actions: [
            Consumer(builder: (context, ref, child) {
              return IconButton(
                  onPressed: () {
                    ref.read(signInProvider).signOutUser(context);
                  },
                  icon: const Icon(Icons.settings));
            })
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              const AnimatedListTile(),
              Expanded(
                child: Consumer(builder: (context, ref, child) {
                  return PageView.builder(
                      scrollBehavior: const ScrollBehavior().copyWith(
                          physics: const NeverScrollableScrollPhysics()),
                      controller: ref.watch(homePagesControler),
                      scrollDirection: Axis.horizontal,
                      itemCount: joinLeavePages.length,
                      itemBuilder: (context, index) => joinLeavePages[index]);
                }),
              )
            ],
          ),
        ));
  }
}
