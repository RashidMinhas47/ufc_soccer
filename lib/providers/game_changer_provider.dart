import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ufc_soccer/utils/firebase_const.dart';
import 'package:uuid/uuid.dart';

final gameServiceProvider = Provider((ref) => GameServiceProvider());

class GameServiceProvider {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void listenToGameChanges() {
    _firestore.collection(GAMES).snapshots().listen((snapshot) {
      for (final doc in snapshot.docs) {
        final Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

        if (data != null && data.containsKey(REMAININGTIME)) {
          final int remainingTime = data[REMAININGTIME] as int;
          final gameId = data[ID] as String;

          if (remainingTime <= 0) {
            _moveToToBePlayed(doc, gameId);
          }
        }
      }
    });
  }

  Future<void> _moveToToBePlayed(DocumentSnapshot gameDoc, gameId) async {
    final Map<String, dynamic>? gameData =
        gameDoc.data() as Map<String, dynamic>?;

    if (gameData != null) {
      await _firestore.collection(TOBEPLAYED).doc(gameId).set(gameData);
      await gameDoc.reference.delete();
    }
  }
}
