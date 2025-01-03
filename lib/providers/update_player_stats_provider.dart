import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_soccer/screens/app_nav_bar.dart';
import 'package:ufc_soccer/utils/firebase_const.dart';

final updatePlayerStatsProvider =
    ChangeNotifierProvider((ref) => UpdatePlayerStatsProvider());

class UpdatePlayerStatsProvider extends ChangeNotifier {
  bool isloading = false;
  final _firestore = FirebaseFirestore.instance;

  List<String> _videoUrls = [];
  List<Map<String, dynamic>> _defaultGameData = [];
  int _updatedTotalGoals = 0;
  int _updatedTotalGames = 0;
  double _updatedAveGoals = 0;

  int get updatedTotalGoals => _updatedTotalGoals;
  List<Map<String, dynamic>> get defaultGameData => _defaultGameData;

  int get updatedTotalGames => _updatedTotalGames;

  double get updatedAveGoals => _updatedAveGoals;

  List<String> get videoUrls => _videoUrls;
  addVideoUrls(value) {
    if (!_videoUrls.contains(value)) {
      _videoUrls.add(value);
      notifyListeners();
    }
    notifyListeners();
  }

  void addNewGameData(Map<String, dynamic> newGame, userId) async {
    // Extract the GAME_TITLE from newGame
    String newGameTitle = newGame[GAME_TITLE];

    // Check if any game in _defaultGameData has the same GAME_TITLE
    bool containsSameTitle =
        _defaultGameData.any((game) => game[GAME_TITLE] == newGameTitle);

    if (!containsSameTitle) {
      updateTotalGames();

      _defaultGameData.add(newGame);
      // final DocumentReference userRef =
      //     FirebaseFirestore.instance.collection(USERS).doc(userId);

      print("Added new game data: $_defaultGameData");
      notifyListeners();
    } else {
      print("Game data with the same GAME_TITLE already exists.");
    }
  }

  int updateTotalGoals(int newValue) {
    int total = _updatedTotalGoals + newValue;
    notifyListeners();
    return total;
  }

  void updateTotalGames() {
    _updatedTotalGames++;
    notifyListeners();
  }

  double updateAveGoals() {
    double avgGoals = _updatedTotalGoals / _updatedTotalGames;
    notifyListeners();

    return avgGoals;
  }

  Future<void> updatePlayerStats(
    String userId,
    BuildContext context,
  ) async {
    try {
      isloading = true;
      final DocumentReference userRef =
          FirebaseFirestore.instance.collection(USERS).doc(userId);
      int totalGoals = 0; // Initialize total goals counter
      for (Map<String, dynamic> gameData in defaultGameData) {
        // Access the GOALS_SCORED property of each map
        int goalsScored = gameData[GOALS_SCORED];
        print('Goals scored: $goalsScored');
        totalGoals += goalsScored; // Add goals scored to total goals
      }
      print('Total goals: $totalGoals');
      await userRef.set({
        USER_GAME_STATS: defaultGameData,
        PLAYER_STATS: {
          TOTAL_GOALS: totalGoals,
          TOTAL_GAMES: defaultGameData.length,
          AVERAGE_GOALS: totalGoals / defaultGameData.length
        },
      }, SetOptions(merge: true));
      notifyListeners();
      bool conditionToStopPopping(Route<dynamic> route) {
        // Check if the route is of type MyRoute
        return route.settings.name == AppNavBar.screen;
      }

      // Navigator.popUntil(context, (route) {
      //   return conditionToStopPopping(route);
      // });
      Navigator.of(context).popUntil((route) => route.isFirst);
      isloading = false;
      print('User data updated successfully.');
    } catch (error) {
      print('Error updating user data: $error');
      // Handle error accordingly
    }
  }

  Future<void> fetchUserData(String userId) async {
    try {
      final settingsDocRef = _firestore.collection(USERS).doc(userId);

      // Fetch existing settings data
      final settingsDocSnapshot = await settingsDocRef.get();
      final data = settingsDocSnapshot.data();
      final getLocations =
          List<Map<String, dynamic>>.from(data?[USER_GAME_STATS] ?? []);
      _defaultGameData = getLocations;
      notifyListeners();
      // Get reference to the user document in the USERS collection
      DocumentReference userRef =
          FirebaseFirestore.instance.collection(USERS).doc(userId);

      // Get the user document snapshot
      DocumentSnapshot userSnapshot = await userRef.get();

      // Check if the document exists
      if (userSnapshot.exists) {
        // Cast the result of data() to Map<String, dynamic>
        Map<String, dynamic>? userData =
            userSnapshot.data() as Map<String, dynamic>?;

        if (userData != null) {
          // Update class variables with values from user data

          _updatedTotalGames = userData[PLAYER_STATS][TOTAL_GAMES] ?? 0;
          _updatedTotalGoals = userData[PLAYER_STATS][TOTAL_GOALS] ?? 0;
          _updatedAveGoals =
              double.parse(userData[PLAYER_STATS][AVERAGE_GOALS]);
          notifyListeners();
        } else {
          print('User data is null');
        }
      } else {
        print('User document does not exist');
      }
      notifyListeners();
    } catch (error) {
      print('Error fetching user data: $error');
    }
  }

  // Future<void> updateUserData(
  //     String userId, Map<String, dynamic> userData) async {
  //   try {
  //     // Get reference to the user document in the USERS collection
  //     DocumentReference userRef =
  //         FirebaseFirestore.instance.collection(USERS).doc(userId);

  //     // Update the user document in Firestore
  //     await userRef.update({PLAYER_STATS: userData});
  //   } catch (error) {
  //     print('Error updating user data: $error');
  //   }
  // }
}
