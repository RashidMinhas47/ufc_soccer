import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ufc_soccer/screens/home/pages/join_&_leave_game.dart';
import 'package:ufc_soccer/screens/profile_screens/game_videos_screen.dart';
import 'package:ufc_soccer/screens/profile_screens/views/user_video_listtile.dart';
import 'package:ufc_soccer/utils/firebase_const.dart';
import 'package:ufc_soccer/widgets/game_video_player.dart';
import 'package:ufc_soccer/widgets/list_of_videos.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PlayerHighlights extends StatefulWidget {
  static const screen = '/PlayerHighlights';

  const PlayerHighlights({super.key, required this.data});
  final List<Map<String, dynamic>> data;
  @override
  _PlayerHighlightsState createState() => _PlayerHighlightsState();
}

class _PlayerHighlightsState extends State<PlayerHighlights> {
  late List<DocumentSnapshot> videos;
  late YoutubePlayerController controller;

  @override
  void initState() {
    super.initState();
    setState(() {
      isloading = true;
    });
    fetchVideos().whenComplete(() => setState(() {
          isloading = false;
        }));
  }

  String? selectedUrl;
  bool isloading = false;

  Future<void> fetchVideos() async {
    final snapshot =
        await FirebaseFirestore.instance.collection(GAMES_HIGHLIGHTS).get();
    setState(() {
      videos = snapshot.docs;
    });
    final initVideo = videos.first;
    final initVideoUrl = initVideo[VIDEO_URL];

    controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(initVideoUrl)!,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
      ),
    );
  }

  // In the GameVideosScreen class
  void onVideoTap(String videoUrl) {
    setState(() {
      selectedUrl = videoUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'User Profile',
          style: GoogleFonts.poppins(fontSize: 20),
        ),
      ),
      body: widget.data == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                selectedUrl == null
                    ? GameVideoPlayer(
                        paddH: 20,
                      )
                    : VideoPlayerScreen(controller),
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.data.length,
                    itemBuilder: (context, i) {
                      final videoData = widget.data[i];
                      final gameTitle = videoData[GAME_TITLE].toString();
                      final videoUrls = List.from(videoData[VIDEO_URL]);

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox.shrink(),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            //   crossAxisCount: 1,
                            //   crossAxisSpacing: 8,
                            //   mainAxisSpacing: 8,
                            // ),
                            itemCount: videoUrls.length,
                            itemBuilder: (context, index) {
                              // Render your video widget here using the videoUrl
                              return UserVideoListTile(
                                videoUrl: videoUrls[index].toString(),
                                videoNumber: "Video ${index + 1}",
                                selectedGame: gameTitle,
                                onTap: () {
                                  setState(() {
                                    selectedUrl = videoUrls[index];
                                    controller.load(
                                        YoutubePlayer.convertUrlToId(
                                            selectedUrl!)!);

                                    // controller = YoutubePlayerController(
                                    //   initialVideoId:
                                    //       YoutubePlayer.convertUrlToId(selectedUrl!)!,
                                    //   flags: const YoutubePlayerFlags(
                                    //     autoPlay: true,
                                    //   ),
                                    // );
                                  });
                                },
                              );
                              // return Container(
                              //   color: Colors.grey,
                              //   child: Center(
                              //     child: Text(
                              //       'Video ${index + 1}',
                              //       style: TextStyle(
                              //         fontSize: 16,
                              //         fontWeight: FontWeight.bold,
                              //       ),
                              //     ),
                              //   ),
                              // );
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  String getThumbnailUrl(String videoUrl) {
    final videoId = YoutubePlayer.convertUrlToId(videoUrl);
    return 'https://img.youtube.com/vi/$videoId/mqdefault.jpg';
  }
}

// class GameVideosScreen extends ConsumerWidget {
//   static const String screen = '/GameVideosScreen';
//   const GameVideosScreen({super.key});

//   @override
//   Widget build(BuildContext context, ref) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text(
//             "Game Videos",
//             style: GoogleFonts.inter(
//               fontWeight: FontWeight.bold,
//               fontSize: 30,
//             ),
//           ),
//           centerTitle: true,
//         ),
//         body: const Column(
//           children: [
//             GameVideoPlayer(
//               paddH: 20,
//             ),
            // Expanded(child: VideoListTiles())
//           ],
//         ));
//   }
// }
