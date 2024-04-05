class GameItem {
  final String name;
  final String date;
  final String time;
  final int maxPlayers;
  final List<String> joinedPlayers;

  GameItem({
    required this.name,
    required this.date,
    required this.time,
    required this.maxPlayers,
    required this.joinedPlayers,
  });
}

class JoinedGameItem extends GameItem {
  JoinedGameItem({
    required super.name,
    required super.date,
    required super.time,
    required super.maxPlayers,
    required super.joinedPlayers,
  });

  // Add any additional methods or properties specific to the joined game item
}

class AvailableGameItem extends GameItem {
  AvailableGameItem({
    required super.name,
    required super.date,
    required super.time,
    required super.maxPlayers,
    required super.joinedPlayers,
  });

  // Add any additional methods or properties specific to the available game item
}

class FullGameItem extends GameItem {
  FullGameItem({
    required super.name,
    required super.date,
    required super.time,
    required super.maxPlayers,
    required super.joinedPlayers,
  });

  // Add any additional methods or properties specific to the full game item
}
