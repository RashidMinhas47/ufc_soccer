import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ufc_soccer/screens/app_nav_bar.dart';
import 'package:ufc_soccer/utils/firebase_const.dart';

final setupGameProvider = ChangeNotifierProvider((ref) => SetupGameProvider());

class SetupGameProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // String? date;
  // String? time;
  // String? location;
  // String? manager;
  // int? maxPlayers;
  bool remixVoting = false;
  int? timeCountdown;
  int? maxPlayers;
  bool isLoading = false;
  bool gameCompletionStatus = false;
  List<String> voters = [];
  List<String> playerUids = [];

  void setMaxPlayers(String value) {
    maxPlayers = int.parse(value);
    notifyListeners();
  }

  void setTimeCountdown(value) {
    timeCountdown = int.parse(value);
  }

  void setVotingCondition(bool value) {
    remixVoting = !remixVoting;
    notifyListeners();
  }

  Future<void> setupGame(BuildContext context,
      {required String date,
      required String time,
      required String location,
      required String manager,
      required int maxPlayers,
      required bool remixVoting,
      required int timeCountdown}) async {
    try {
      isLoading = true;
      final auth = FirebaseAuth.instance;
      User user = auth.currentUser!;
      notifyListeners();

      if (remixVoting) {
        // await _firestore.collection(ADMINUIDS).add({
        //   UID: user.uid,
        //   FULLNAME: user.displayName,
        //   EMAIL: user.email,
        // });
        // final totalPlayers = await _firestore.collection(USERS)
        // try {
        // Fetch all documents from the USERS collection
        // final QuerySnapshot querySnapshot =
        //     await _firestore.collection(USERS).get();

        // Extract the fullName property from each document and store in a list
        // List<String> playerUIDs =
        //     querySnapshot.docs.map((doc) => doc[UID] as String).toList();
        // List<String> playerNames =
        //     querySnapshot.docs.map((doc) => doc[FULLNAME] as String).toList();

        // List<Map<String, dynamic>> joinedPlayersData = [];

        // for (int i = 0; i < playerUIDs.length; i++) {
        //   Map<String, dynamic> playerData = {
        //     PLAYERUIDS: playerUIDs[i],
        //     FULLNAME: playerNames[i]
        //   };
        //   joinedPlayersData.add(playerData);
        // }
        // Now 'fullNames' contains all the fullName values from the USERS collection
        // print('PlayerUids: $playerUIDs');
// } catch (error) {
//   print('Error retrieving full names: $error');
// }
        await _firestore.collection(GAMES).add({
          ADMINNAME: user.displayName,
          ID: _firestore.collection(GAMES).doc().id,
          IMAGEURL: "",
          DATE: date,
          TIME: time,
          LOCATION: location,
          MANAGERS: manager,
          MAXPLAYER: maxPlayers,
          REMIXVOTING: remixVoting,
          TIMECOUNTDOWN: timeCountdown,
          GAMESTATUS: gameCompletionStatus,
          JOINEDPLAYERS: <String>[],
          JOINEDPLAYERNAMES: <String>[],

          VOTERS: voters,
          // PLAYERUIDS: playerUIDs,
        });
      } else {
        final QuerySnapshot querySnapshot =
            await _firestore.collection(USERS).get();

        // Extract the fullName property from each document and store in a list
        List<String> playerUIDs =
            querySnapshot.docs.map((doc) => doc[UID] as String).toList();
        //     List<String> playerNames =
        //     querySnapshot.docs.map((doc) => doc[UID] as String).toList();
        //      List<Map<String, dynamic>> joinedPlayersData = [];

        // for (int i = 0; i < playerUIDs.length; i++) {
        //   Map<String, dynamic> playerData = {
        //     PLAYERUIDS: playerUIDs[i],
        //     FULLNAME: playerNames[i]
        //   };
        //   joinedPlayersData.add(playerData);
        // }

        // Now 'fullNames' contains all the fullName values from the USERS collection
        print('Player Uids: $playerUIDs');
        await _firestore.collection(GAMES).add({
          ADMINNAME: user.displayName,
          DATE: date,
          TIME: time,
          LOCATION: location,
          MANAGERS: manager,
          MAXPLAYER: maxPlayers,
          REMIXVOTING: remixVoting,
          TIMECOUNTDOWN: timeCountdown,
          GAMESTATUS: gameCompletionStatus,
          JOINEDPLAYERS: <String>[],
          JOINEDPLAYERNAMES: <String>[],
          // PLAYERUIDS: playerUIDs,
        });
      }
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Game is add Successfully")));
      isLoading = false;
      notifyListeners();
    } catch (error) {
      print('Error setting up new game: $error');
    }
  }
}
