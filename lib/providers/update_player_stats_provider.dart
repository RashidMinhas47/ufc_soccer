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
      _defaultGameData.add(newGame);
      final DocumentReference userRef =
          FirebaseFirestore.instance.collection(USERS).doc(userId);

      await userRef.update({
        PLAYER_STATS: {
          TOTAL_GAMES: _updatedTotalGames,
          TOTAL_GOALS: _updatedAveGoals,
          AVERAGE_GOALS: _updatedAveGoals
        }
      });
      print("Added new game data: $_defaultGameData");
      notifyListeners();
    } else {
      print("Game data with the same GAME_TITLE already exists.");
    }
  }

  bool conditionToStopPopping(Route<dynamic> route) {
    // Check if the route is of type MyRoute
    return route.settings.name == AppNavBar.screen;
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
    _updatedAveGoals = _updatedTotalGoals / _updatedTotalGames;
    notifyListeners();

    return _updatedAveGoals;
  }

  Future<void> updatePlayerStats(String userId, BuildContext context,
      {required int totalGoals,
      required int totalGames,
      required double aveGoals}) async {
    try {
      isloading = true;
      final DocumentReference userRef =
          FirebaseFirestore.instance.collection(USERS).doc(userId);

      await userRef.update({
        USER_GAME_STATS: defaultGameData,
      });
      notifyListeners();

      Navigator.popUntil(context, (route) {
        return conditionToStopPopping(route);
      });
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
          _updatedAveGoals = userData[PLAYER_STATS][AVERAGE_GOALS] ?? 0.0;
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
