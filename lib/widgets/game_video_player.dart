import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_soccer/providers/game_info_providers.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class GameVideoPlayer extends StatelessWidget {
  const GameVideoPlayer({
    super.key,
    this.paddH = 0,
  });
  final double paddH;

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final videoId = ref.watch(gameInfoProvider).videoId!;
      YoutubePlayerController _controller = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          isLive: true,
          mute: true,
        ),
      );
      return AspectRatio(
          aspectRatio: 16 / 9,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: paddH, vertical: 10),
            color: const Color.fromARGB(255, 221, 221, 221),
            child: videoId.isEmpty
                ? Center(
                    child: Icon(Icons.play_arrow),
                  )
                : YoutubePlayer(
                    controller: _controller,
                    liveUIColor: Colors.amber,
                  ),
          ));
    });
  }
}
