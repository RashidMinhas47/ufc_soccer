class GameModel {
  String date;
  String name;
  String time;
  String location;
  String manager;
  int maxPlayer;
  bool remixVoting;
  int remainingTime;
  String id;
  List<String> joinedPlayerUids;
  List<String> joinedPlayerNames;
  // List<String> voters;

  GameModel({
    required this.id,
    // required this.voters,
    required this.date,
    required this.joinedPlayerNames,
    required this.joinedPlayerUids,
    required this.name,
    required this.time,
    required this.location,
    required this.manager,
    required this.maxPlayer,
    required this.remixVoting,
    required this.remainingTime,
  });
}
