import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ufc_soccer/screens/profile_screens/game_videos_screen.dart';
import 'package:ufc_soccer/screens/profile_screens/views/user_video_listtile.dart';
import 'package:ufc_soccer/screens/profile_screens/views/videos_screen.dart';
import 'package:ufc_soccer/utils/firebase_const.dart';

class YourScreen extends StatefulWidget {
  final String userId; // User ID for whom you want to fetch videos

  const YourScreen({super.key, required this.userId});

  @override
  _YourScreenState createState() => _YourScreenState();
}

class _YourScreenState extends State<YourScreen> {
  List<Map<String, dynamic>> userVideos = [];
  List<String> videoLinks = [];

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
        final userGameStats = userData[USER_GAME_STATS] as List<dynamic>;
        // for (var stats in userGameStats) {
        //   if (stats is Map<String, dynamic> && stats.containsKey('VIDEO_URL')) {
        //     final videoUrls = stats[VIDEO_URL] as List<String>;
        //     setState(() {
        //       userVideos.addAll(videoUrls.map((url) => url.toString()));
        //     });
        //   }
        // }
        for (var stats in userGameStats) {
          if (stats is Map<String, dynamic> && stats.containsKey(VIDEO_URL)) {
            final videoUrls = stats[VIDEO_URL] as List<dynamic>;
            setState(() {
              for (var url in videoUrls) {
                if (url is String) {
                  setState(() {
                    videoLinks.add(url);
                    print(
                        ".............>>>>>>>>>>>>>>>$videoUrls<<<<<<<<<<<<<..............");
                  });
                }
              }
            });
          }
        }
      }
    } catch (error) {
      print('Error fetching user videos: $error');
    }
  }

  // Future<void> fetchUserVideos() async {
  //   try {
  //     final snapshot = await FirebaseFirestore.instance
  //         .collection(USERS)
  //         .doc(widget.userId)
  //         .get();

  //     final userData = snapshot.data();
  //     if (userData != null && userData.containsKey(USER_GAME_STATS)) {
  //       final userGameStats = List<Map<String, dynamic>>.from(
  //         userData[USER_GAME_STATS],
  //       );
  //       setState(() {
  //         userVideos.addAll(userGameStats);
  //       });
  //     }
  //   } catch (error) {
  //     print('Error fetching user videos: $error');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Videos'),
      ),
      body: Column(
        children: [
          // for (int i = 0; i < userVideos.length; i++)
          // Expanded(
          //   child: ListView.builder(
          //       itemCount: 1,
          //       itemBuilder: (context, i) {
          //         return Container(
          //           height: 200,
          //           child: ListView.builder(
          //             itemCount: videoLinks.length,
          //             itemBuilder: (context, index) {
          //               String videoUrl = '';
          //               String videoNumber = '';
          //               String selectedGame = '';

          //               final videoData = userVideos[i];
          //               videoUrl =
          //                   List<String>.from(videoData[VIDEO_URL])[index];
          //               videoNumber = (index + 1)
          //                   .toString(); // Video number starts from 1
          //               selectedGame = videoData[GAME_TITLE];
          //               return UserVideoListTile(
          //                 videoUrl: videoLinks[index],
          //                 videoNumber: videoLinks[index],
          //                 selectedGame: videoLinks[index],
          //               );
          //             },
          //           ),
          //         );
          //       }),
          // ),
          Expanded(
            child: ListView.builder(
              itemCount: videoLinks.length,
              itemBuilder: (context, index) {
                String videoUrl = '';
                String videoNumber = '';
                String selectedGame = '';

                final videoData = userVideos[0];
                videoUrl = List<String>.from(videoData[VIDEO_URL])[index];
                videoNumber =
                    (index + 1).toString(); // Video number starts from 1
                selectedGame = videoData[GAME_TITLE];
                return UserVideoListTile(
                  onTap: () {},
                  videoUrl: videoLinks[index],
                  videoNumber: videoLinks[index],
                  selectedGame: videoLinks[index],
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class UserProfileScreen extends StatefulWidget {
  final String userUid;

  const UserProfileScreen({super.key, required this.userUid});

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  List<Map<String, dynamic>>? data;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      // final userUid = FirebaseAuth.instance.currentUser!.uid;
      final snapshot = await FirebaseFirestore.instance
          .collection(USERS)
          .doc(widget.userUid)
          .get();

      final userData = snapshot.data();
      if (userData != null) {
        setState(() {
          data = List<Map<String, dynamic>>.from(userData[USER_GAME_STATS]);
        });
      }
    } catch (error) {
      print('Error fetching user data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'User Profile',
          style: GoogleFonts.poppins(fontSize: 20),
        ),
      ),
      body: data == null
          ? SizedBox.shrink()
          : ListView.builder(
              itemCount: data!.length,
              itemBuilder: (context, i) {
                final videoData = data![i];
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
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        PlayerHighlights(data: data!)));
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
    );
  }
}
