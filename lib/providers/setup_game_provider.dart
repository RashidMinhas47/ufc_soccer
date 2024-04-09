import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ufc_soccer/screens/app_nav_bar.dart';
import 'package:ufc_soccer/utils/firebase_const.dart';
import 'package:uuid/uuid.dart';

final setupGameProvider = ChangeNotifierProvider((ref) => SetupGameProvider());

class SetupGameProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool isVoted = false;
  void setVote() {
    isVoted = true;
    notifyListeners();
  }

  Stream<List<String>> getVotersStream(String gameId) {
    return _firestore
        .collection('GAMES')
        .doc(gameId)
        .snapshots()
        .map((snapshot) {
      final data = snapshot.data();
      if (data == null || !data.containsKey('VOTERS')) {
        return []; // Return an empty list if no voters are found
      }
      return List<String>.from(data['VOTERS']);
    });
  }

  Stream<bool> isUserAlreadyVotedStream(String gameId, String userId) {
    return getVotersStream(gameId).map((voters) {
      if (voters != null) {
        return voters.contains(userId);
      } else {
        return false;
      }
    });
  }

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

  Future<void> voteForYes(String gameId) async {
    try {
      List<String> userUids = [];
      try {
        final DocumentSnapshot gameDoc =
            await _firestore.collection(GAMES).doc(gameId).get();
        final Map<String, dynamic>? data =
            gameDoc.data() as Map<String, dynamic>?;
        if (data == null || !data.containsKey(VOTERS)) {
          userUids = []; // Return an empty list if no voters are found
        }
        userUids = List<String>.from(data?[VOTERS]);
      } catch (error) {
        print('Error fetching voters: $error');
      }
      final auth = FirebaseAuth.instance;
      User user = auth.currentUser!;
      String userId = user.uid;
      String userName = user.displayName ??
          'Unknown User'; // Use a default name if display name is not available

      if (!userUids.contains(userId)) {
        userUids.add(userId);
        await _firestore.collection(GAMES).doc(gameId).update({
          VOTEFORYES: FieldValue.arrayUnion([
            {UID: userId, FULLNAME: userName}
          ]),
          VOTERS: userUids
        });
      }
      // await _firestore.collection(GAMES).get().then((querySnapshot) {
      //   querySnapshot.docs.forEach((doc) async {
      //     await _firestore.collection(GAMES).doc(doc.id).update({
      //       VOTEFORYES: FieldValue.arrayUnion([
      //         {UID: userId, FULLNAME: userName}
      //       ])
      //     });
      //   });
      // });
    } catch (error) {
      print('Error voting for "Yes": $error');
    }
  }

  Future<void> voteForNo(String gameId) async {
    try {
      List<String> userUids = [];
      try {
        final DocumentSnapshot gameDoc =
            await _firestore.collection(GAMES).doc(gameId).get();
        final Map<String, dynamic>? data =
            gameDoc.data() as Map<String, dynamic>?;
        if (data == null || !data.containsKey(VOTERS)) {
          userUids = []; // Return an empty list if no voters are found
        }
        userUids = List<String>.from(data?[VOTERS]);
      } catch (error) {
        print('Error fetching voters: $error');
      }
      final auth = FirebaseAuth.instance;
      User user = auth.currentUser!;
      // List<String> voterNames = [];
      // if (!voterNames.contains(user.displayName)) {
      //   voterNames.add(user.displayName!);
      // }
      String userId = user.uid;
      String userName = user.displayName ??
          'Unknown User'; // Use a default name if display name is not available
      if (!userUids.contains(userId)) {
        userUids.add(userId);
        await _firestore.collection(GAMES).doc(gameId).update({
          VOTEFORNO: FieldValue.arrayUnion([
            {UID: userId, FULLNAME: userName}
          ]),
          VOTERS: userUids
        });
      }
      // await _firestore.collection(GAMES).get().then((querySnapshot) {
      //   querySnapshot.docs.forEach((doc) async {
      //     await _firestore.collection(GAMES).doc(doc.id).update({
      //       VOTEFORNO: FieldValue.arrayUnion([
      //         {UID: userId, FULLNAME: userName}
      //       ])
      //     });
      //   });
      // });
    } catch (error) {
      print('Error voting for "No": $error');
    }
  }

  Future<void> setupGame(BuildContext context,
      {required String date,
      required String time,
      required String location,
      required String manager,
      required int maxPlayers,
      required bool remixVoting,
      required int timeCountdown,
      required String title}) async {
    try {
      String newKey = Uuid().v4();

      isLoading = true;
      final auth = FirebaseAuth.instance;
      User user = auth.currentUser!;
      notifyListeners();
      // Calculate end time of game setup
      DateTime setupEndTime =
          DateTime.now().add(Duration(hours: timeCountdown));

      if (remixVoting) {
        await _firestore.collection(GAMES).doc(newKey).set({
          ADMINNAME: user.displayName,
          TITLE: title,
          ID: newKey,
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
          VOTETIMER: setupEndTime,

          VOTERS: <String>[],
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
        await _firestore.collection(GAMES).doc(newKey).set({
          TITLE: title,

          ADMINNAME: user.displayName,
          ID: newKey,
          DATE: date,
          TIME: time,
          VOTETIMER: setupEndTime,
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
      // Start a timer to update remaining time
      Timer.periodic(const Duration(seconds: 1), (timer) {
        // Calculate remaining time until setup end
        Duration remainingTime = setupEndTime.difference(DateTime.now());

        // Update the UI or Firestore with remaining time
        // You can use a StreamBuilder in your UI to listen to this value
        // and update the UI accordingly.
        _firestore.collection(GAMES).doc(newKey).update({
          REMAININGTIME:
              remainingTime.inSeconds, // Store remaining time in Firestore
        });

        // If setup time is over, cancel the timer
        if (remainingTime.inSeconds <= 0) {
          timer.cancel();
        }
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Game is add Successfully")));
      isLoading = false;
      notifyListeners();
    } catch (error) {
      print('Error setting up new game: $error');
    }
  }

  void setupGameListener() {
    _firestore.collection('GAMES').snapshots().listen((snapshot) {
      snapshot.docs.forEach((doc) {
        int remainingTime = doc.data()['REMAININGTIME'];
        if (remainingTime == 0) {
          // Game has been finalized, move it to FINALIZEDGAMES collection
          finalizeGame(doc);
        }
      });
    });
  }

  void finalizeGame(DocumentSnapshot gameDoc) async {
    try {
      // Get data from the game document
      Map<String, dynamic> gameData = gameDoc.data() as Map<String, dynamic>;

      // Add additional logic or data transformation as needed

      // Create a new document in FINALIZEDGAMES collection
      await _firestore.collection('FINALIZEDGAMES').add(gameData);

      // Optionally, delete the document from GAMES collection
      await gameDoc.reference.delete();
    } catch (error) {
      print('Error finalizing game: $error');
    }
  }
}
