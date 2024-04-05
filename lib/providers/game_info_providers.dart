import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameInfoState extends ChangeNotifier {
  // String blueTeamScore = '';
  int _redTeamScore = 0;
  int _blueTeamScore = 0;
  int _goalsCurrentGame = 0;
  int get goalsCurrentGame => _goalsCurrentGame;
  int get blueTeamScore => _blueTeamScore;

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
}

final gameInfoProvider =
    ChangeNotifierProvider<GameInfoState>((ref) => GameInfoState());
