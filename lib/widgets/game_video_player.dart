import 'package:flutter/material.dart';

class GameVideoPlayer extends StatelessWidget {
  const GameVideoPlayer({
    super.key,
    this.paddH = 0,
  });
  final double paddH;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: paddH, vertical: 10),
        color: const Color.fromARGB(255, 221, 221, 221),
        child: Center(
          child: Icon(
            Icons.play_arrow,
            size: 49,
          ),
        ),
      ),
    );
  }
}
