import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ufc_soccer/utils/firebase_const.dart';

final gameJoinProvider = ChangeNotifierProvider((ref) => GameJoinProvider());

class GameJoinProvider extends ChangeNotifier {
  bool isJoined = false;
  // List<bool> isJoinedList = [];
  // @override
  // void dispose() {
  //   // Clean up any resources here
  //   super.dispose();
  //   gameId = [];
  // }

  List<String> gameId = [];
  // addJoinedList(bool newValue) {
  //   isJoinedList.add(newValue);
  //   notifyListeners();
  // }

  addGameIds(String newId) {
    if (!gameId.contains(newId)) {
      gameId.add(newId);
      notifyListeners();
    }
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> joinGame(String gameId, String playerName) async {
    try {
      // Get a reference to the game document
      DocumentReference gameRef = _firestore.collection(GAMES).doc(gameId);

      // Get the current game data
      DocumentSnapshot gameSnapshot = await gameRef.get();
      Map<String, dynamic> gameData =
          gameSnapshot.data() as Map<String, dynamic>;

      // Check if the game is full
      int maxPlayers = gameData[MAXPLAYER] ?? 0;
      List<String> joinedPlayers =
          List<String>.from(gameData[JOINEDPLAYERS] ?? []);

      if (joinedPlayers.length >= maxPlayers) {
        throw Exception('Game is full');
      }

      // Add the player to the list of joined players
      joinedPlayers.add(playerName);

      // Update the game document with the new list of joined players
      await gameRef.update({
        JOINEDPLAYERS: joinedPlayers,
      });

      // Decrement the max players count
      await gameRef.update({
        MAXPLAYER: maxPlayers - 1,
      });

      // Notify listeners that the game data has been updated
      notifyListeners();
    } catch (error) {
      print('Error joining game: $error');
      // You can handle errors or propagate them to the UI as needed
    }
  }
}
