import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ufc_soccer/screens/profile_screens/views/user_video_listtile.dart';
import 'package:ufc_soccer/utils/firebase_const.dart';

class YourScreen extends StatefulWidget {
  final String userId; // User ID for whom you want to fetch videos

  const YourScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _YourScreenState createState() => _YourScreenState();
}

class _YourScreenState extends State<YourScreen> {
  List<Map<String, dynamic>> userVideos = [];

  @override
  void initState() {
    super.initState();
    fetchUserVideos();
  }

  Future<void> fetchUserVideos() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection(USERS)
          .doc(widget.userId)
          .get();

      final userData = snapshot.data();
      if (userData != null && userData.containsKey(USER_GAME_STATS)) {
        final userGameStats = List<Map<String, dynamic>>.from(
          userData[USER_GAME_STATS],
        );
        setState(() {
          userVideos = userGameStats;
        });
      }
    } catch (error) {
      print('Error fetching user videos: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Videos'),
      ),
      body: ListView.builder(
        itemCount: userVideos.first.length,
        itemBuilder: (context, index) {
          final videoData = userVideos[index];
          String videoUrl = List<String>.from(videoData[VIDEO_URL]).toList()[1];
          final videoNumber =
              (index + 1).toString(); // Video number starts from 1
          final selectedGame = videoData[GAME_TITLE];

          return UserVideoListTile(
            videoUrl: videoUrl,
            videoNumber: videoNumber,
            selectedGame: selectedGame,
          );
        },
      ),
    );
  }
}
