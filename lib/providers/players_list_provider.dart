import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ufc_soccer/utils/firebase_const.dart';

final playerListProvider =
    FutureProvider.autoDispose<List<String>>((ref) async {
  // Access the Firestore instance
  final firestore = FirebaseFirestore.instance;

  // Retrieve the UID list from the GAMES collection
  List<String> playerUIDs =
      await _fetchPlayerUIDsFromGamesCollection(firestore);

  // Fetch player names for each UID from the USER collection
  List<String> playerNames =
      await _fetchPlayerNamesFromUserCollection(firestore, playerUIDs);

  return playerNames;
});

Future<List<String>> _fetchPlayerUIDsFromGamesCollection(
    FirebaseFirestore firestore) async {
  // Query the GAMES collection to retrieve player UIDs
  QuerySnapshot gamesSnapshot = await firestore.collection(GAMES).get();

  // Extract player UIDs from the documents
  List<String> playerUIDs = List.from(gamesSnapshot.docs
      .map((doc) => doc[JOINEDPLAYERS])
      .expand((uids) => uids)
      .toList());

  return playerUIDs;
}

Future<List<String>> _fetchPlayerNamesFromUserCollection(
    FirebaseFirestore firestore, List<String> playerUIDs) async {
  // Query the USER collection to retrieve player names based on UIDs
  QuerySnapshot usersSnapshot = await firestore
      .collection(USERS)
      .where(FieldPath.documentId, whereIn: playerUIDs)
      .get();

  // Extract player names from the documents
  List<String> playerNames =
      List.from(usersSnapshot.docs.map((doc) => doc[FULLNAME]).toList());

  return playerNames;
}
