import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ufc_soccer/screens/home/home_screen.dart';
import 'package:ufc_soccer/screens/profile_screens/game_videos_screen.dart';
import 'package:ufc_soccer/screens/profile_screens/profile_screen.dart';
import 'package:ufc_soccer/utils/constants.dart';
import 'package:ufc_soccer/utils/image_urls.dart';

class AppNavBar extends ConsumerStatefulWidget {
  static const String screen = '/AppNavBar';
  const AppNavBar({super.key});

  @override
  ConsumerState<AppNavBar> createState() => _AppNavBarState();
}

class _AppNavBarState extends ConsumerState<AppNavBar> {
  List<Widget> screens = const [
    NextGameScreen(),
    GameVideosScreen(),
    ProfileScreen(),
  ];
  int currentIndex = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens.elementAt(currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          // ref.watch(userDataProvider).fetchUserData();
          setState(() {
            currentIndex = index;
          });
        },
        selectedLabelStyle: GoogleFonts.poppins(),
        unselectedLabelStyle: GoogleFonts.poppins(),
        unselectedItemColor: Colors.black,
        selectedItemColor: Colors.blue,
        items: [
          BottomNavigationBarItem(
              label: 'Game',
              icon: SvgPicture.asset(
                AppSvg.footballIcon,
                height: 20,
                color: currentIndex == 0 ? kPrimaryColor : kBlackColor,
              )),
          BottomNavigationBarItem(
              label: "Videos",
              icon: SvgPicture.asset(
                AppSvg.youtubeIcon,
                height: 30,
                color: currentIndex == 1
                    ? Color.fromARGB(255, 236, 18, 3)
                    : kBlackColor,
              )),
          const BottomNavigationBarItem(
              label: "Profile",
              icon: Icon(
                Icons.person_rounded,
              )),
        ],
      ),
    );
  }
}
