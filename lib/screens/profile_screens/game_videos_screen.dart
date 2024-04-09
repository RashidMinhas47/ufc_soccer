import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ufc_soccer/screens/home/pages/join_&_leave_game.dart';
import 'package:ufc_soccer/utils/firebase_const.dart';
import 'package:ufc_soccer/widgets/game_video_player.dart';
import 'package:ufc_soccer/widgets/list_of_videos.dart';
import 'package:ufc_soccer/widgets/player_stats.dart';
import 'package:ufc_soccer/widgets/user_card.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayerScreen extends StatelessWidget {
  // final String videoUrl;
  final YoutubePlayerController controller;
  VideoPlayerScreen(this.controller);

//   @override
//   _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
// }

// class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
//   late YoutubePlayerController _controller;

//   @override
//   void initState() {
//     super.initState();

//   }

  @override
  Widget build(BuildContext context) {
    return
        // Scaffold(
        //   appBar: AppBar(
        //     title: Text('Video Player'),
        //   ),
        //   body:
        //    Column(
        //     children: [
        AspectRatio(
      aspectRatio: 16 / 9, // 14 / 9
      child: YoutubePlayer(
        controller: controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.blueAccent,
      ),
    );
    //   ],
    // ),
    // );
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   _controller.dispose();
  // }
}

class GameVideosScreen extends StatefulWidget {
  static const screen = '/GameVideosScreen';

  const GameVideosScreen({super.key});
  @override
  _GameVideosScreenState createState() => _GameVideosScreenState();
}

class _GameVideosScreenState extends State<GameVideosScreen> {
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
          "Game Videos",
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        centerTitle: true,
      ),
      body: isloading
          ? progressWidget
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  children: [
                    selectedUrl == null
                        ? GameVideoPlayer(
                            paddH: 20,
                          )
                        : VideoPlayerScreen(controller),
                    SizedBox(
                      height: size.height * 0.4,
                      width: size.width,
                      child: ListView.builder(
                        itemCount: videos.length,
                        itemBuilder: (context, index) {
                          final video = videos[index];
                          final videoUrl = video[VIDEO_URL];
                          final subtitle = video[SELECTED_GAME];
                          // final gameName = video.id; // Assuming game name is the document ID
                          final videoTitle =
                              'Video ${index + 1}'; // You can customize this
                          return VideoListTileCustom(
                              onTap: () {
                                setState(() {
                                  selectedUrl = videoUrl;
                                  controller.load(YoutubePlayer.convertUrlToId(
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
                              title: videoTitle,
                              subtitle: subtitle,
                              imageUrl: getThumbnailUrl(videoUrl));
                          // ListTile(
                          //   leading: Image.network(getThumbnailUrl(videoUrl)),
                          //   title: Text(videoTitle),
                          //   subtitle: Text(subtitle),
                          //   onTap: () {
                          //     Navigator.push(
                          //       context,
                          //       MaterialPageRoute(
                          //         builder: (context) => VideoPlayerScreen(videoUrl),
                          //       ),
                          //     );
                          //   },
                          // );
                        },
                      ),
                    ),
                  ],
                ),
              ),
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
