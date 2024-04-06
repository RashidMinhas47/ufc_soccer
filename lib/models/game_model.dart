class GameModel {
  String date;
  String name;
  String time;
  String location;
  String manager;
  int maxPlayer;
  bool remixVoting;
  int timeCountdown;
  String id;
  List<String> joinedPlayerUids;
  List<String> joinedPlayerNames;

  GameModel({
    required this.id,
    required this.date,
    required this.joinedPlayerNames,
    required this.joinedPlayerUids,
    required this.name,
    required this.time,
    required this.location,
    required this.manager,
    required this.maxPlayer,
    required this.remixVoting,
    required this.timeCountdown,
  });
}
