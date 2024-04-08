import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_soccer/screens/app_nav_bar.dart';
import 'package:ufc_soccer/utils/firebase_const.dart';
import 'package:uuid/uuid.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class GameInfoState extends ChangeNotifier {
  // String blueTeamScore = '';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoading = false;

  List<String> _selectedPlayers = [];
  List<String> _selectedPlayerUIds = [];

  bool get isLoading => _isLoading;
  int _redTeamScore = 0;
  int _blueTeamScore = 0;
  int _goalsCurrentGame = 0;
  int get goalsCurrentGame => _goalsCurrentGame;
  int get blueTeamScore => _blueTeamScore;
  List<String> _playedGames = [];
  String? _selectGame;
  String? _selectPlayer;
  String? _selectPlayerUid;
  String videoId = '';
  String? get selectPlayer => _selectPlayer;
  String? get selectUid => _selectPlayerUid;

  List<String> get selectedPlayers => _selectedPlayers;
  List<String> get selectedUids => _selectedPlayerUIds;

  List<String> get playedGames => _playedGames;
  String? get selectGame => _selectGame;

  void setUrl(newUrl) {
    videoId = YoutubePlayer.convertUrlToId(newUrl)!;
    notifyListeners();
    print(videoId);
  }
// BBAyRBTfsOU

  int get redTeamScore => _redTeamScore;

  blueTeamScoreAdd() {
    _blueTeamScore++;
    notifyListeners();
  }

  blueTeamScoreRemove() {
    _blueTeamScore--;
    notifyListeners();
  }

  redTeamScoreAdd() {
    _redTeamScore++;
    notifyListeners();
  }

  redTeamScoreRemove() {
    _redTeamScore--;
    notifyListeners();
  }

  goalsCurrentGameAdd() {
    _goalsCurrentGame++;
    notifyListeners();
  }

  goalsCurrentGameRemove() {
    _goalsCurrentGame--;
    notifyListeners();
  }

  void selectedGame(value) {
    _selectGame = value;
    notifyListeners();
  }

  void selectedPlayer(value) {
    _selectPlayer = value;
    notifyListeners();
  }

  void selectedPlayerUid(value, List<String> uids) {
    int index = _selectedPlayers.indexOf(value);
    _selectPlayerUid = uids[index];
    notifyListeners();
  }

  Future<void> fetchDropdownItems() async {
    try {
      final QuerySnapshot snapshot =
          await _firestore.collection(TOBEPLAYED).get();

      final List<String> snaps =
          snapshot.docs.map((doc) => '${doc[TITLE]}').toList();
      _playedGames = snaps;
      notifyListeners();
    } catch (error) {
      print('Error fetching dropdown items: $error');
    }
  }

  Future<List<String>> _fetchUserNames(List<String> userIds) async {
    try {
      final List<String> usernames = [];

      // Fetch usernames for each UID
      for (String uid in userIds) {
        final DocumentSnapshot userSnapshot =
            await _firestore.collection(USERS).doc(uid).get();
        final username =
            userSnapshot.get(FULLNAME); // Access data using get() method
        if (username != null) {
          usernames.add(
              username.toString()); // Convert to String and add to the list
        }
      }

      return usernames;
    } catch (error) {
      print('Error fetching usernames: $error');
      return []; // Return an empty list if an error occurs
    }
  }

  Future<void> fetchSelectedPlayers(String selectedTitle) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection(TOBEPLAYED)
          .where(TITLE, isEqualTo: selectedTitle)
          .get();

      if (snapshot.docs.isNotEmpty) {
        _selectedPlayerUIds =
            List<String>.from(snapshot.docs.first[JOINEDPLAYERS]);

        _selectedPlayers = await _fetchUserNames(_selectedPlayerUIds);
      } else {
        _selectedPlayers =
            []; // Clear the list if no matching document is found
      }

      notifyListeners();
    } catch (error) {
      print('Error fetching selected players: $error');
    }
  }

  Future<void> sendGameHighlights(
    BuildContext context, {
    required String selectedGame,
    required String videoUrl,
    required int blueTeamScore,
    required int redTeamScore,
  }) async {
    String newKey = Uuid().v4();

    _isLoading = true;
    notifyListeners();

    try {
      // Query to check if a document with the same title already exists
      QuerySnapshot querySnapshot = await _firestore
          .collection(GAMES_HIGHLIGHTS)
          .where(SELECTED_GAME, isEqualTo: selectedGame)
          .get();
      if (selectGame!.isNotEmpty && videoId.isNotEmpty) {
        if (querySnapshot.docs.isEmpty) {
          await _firestore.collection(GAMES_HIGHLIGHTS).doc(newKey).set({
            ID: newKey,
            SELECTED_GAME: selectedGame,
            VIDEO_URL: videoUrl,
            BLUE_TEAM_SCORE: blueTeamScore,
            RED_TEAM_SCORE: redTeamScore,
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('selected game data is already add')));
        }
      }

      // Notify listeners that the operation is completed
      _isLoading = false;
      notifyListeners();
      Navigator.pushReplacementNamed(context, AppNavBar.screen);
    } catch (error) {
      print('Error sending game highlights: $error');
      // Handle error
      _isLoading = false;
      notifyListeners();
    }
  }
}

final gameInfoProvider =
    ChangeNotifierProvider<GameInfoState>((ref) => GameInfoState());
