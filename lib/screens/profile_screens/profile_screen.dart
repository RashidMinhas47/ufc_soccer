import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ufc_soccer/models/current_user_model.dart';
import 'package:ufc_soccer/providers/user_data.dart';
import 'package:ufc_soccer/screens/admin/game_admin.dart';
import 'package:ufc_soccer/screens/home/pages/join_&_leave_game.dart';
import 'package:ufc_soccer/screens/profile_screens/game_videos_screen.dart';
import 'package:ufc_soccer/screens/profile_screens/views/list_of_videos.dart';
import 'package:ufc_soccer/utils/constants.dart';
import 'package:ufc_soccer/utils/image_urls.dart';
import 'package:ufc_soccer/widgets/list_of_videos.dart';
import 'package:ufc_soccer/widgets/player_stats.dart';
import 'package:ufc_soccer/widgets/user_card.dart';

class ProfileScreen extends ConsumerWidget {
  static const String screen = '/ProfileScreen';
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    // ref.watch(userDataProvider).fetchUserData();
    final userD = ref.watch(userDataProvider);

    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Player Profile",
            style: GoogleFonts.inter(
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
          centerTitle: true,
        ),
        body: Consumer(builder: (context, ref, child) {
          // ref.watch(userDataProvider).fetchUserData();

          return SingleChildScrollView(
            child: Column(
              children: [
                // FutureBuilder(
                //     future: userD.state,
                //     builder: (context, child) {
                ListTile(
                    leading: const Icon(
                      Icons.admin_panel_settings_rounded,
                      size: 40,
                    ),
                    title: Text(
                      "Admin Panel",
                      style: GoogleFonts.poppins(fontSize: 20),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, GameAdmin.screen);
                      //   },
                      // );
                    }),

                Consumer(builder: (context, ref, child) {
                  // final userListAsyncValue = ref.watch(userStreamProvider);
                  // return userListAsyncValue.when(
                  //     data: (data) {
                  //       Future.delayed(Duration(seconds: 4))
                  //           .whenComplete(() {});
                  //       return UserProfileCard(
                  //         image: data.imageUrl,
                  //         label: "${data.fullName}[${data.jersyNumber}]",
                  //         subtitle: data.nickName,
                  //         subtitle2: data.positions.join(', '),
                  //       );
                  //     },
                  //     loading: () => progressWidget,
                  //     error: (error, stackTrace) =>
                  //         Center(child: Text('Error: $error')));

                  final userD =
                      ref.watch(userDataProvider); // Access the user data

                  return UserProfileCard(
                    image: userD.imageUrl,
                    label: "${userD.fullName}[${userD.jersyNumber}]",
                    subtitle: userD.nickname,
                    subtitle2: userD.positions.join(', '),
                  );
                }),
                const PlayerStatsCard(),
                SizedBox(
                    height: 400,
                    child: UserProfileScreen(
                      userUid: userD.userUid,
                    ))
              ],
            ),
          );
        }));
  }
}
