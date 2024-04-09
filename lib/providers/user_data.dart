import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_soccer/screens/app_nav_bar.dart';
import 'package:ufc_soccer/screens/authentication_screen.dart';
import 'package:ufc_soccer/utils/firebase_const.dart';

final userDataProvider = ChangeNotifierProvider((ref) => UserDataProvider());

// final userDataProvider = ChangeNotifierProvider((ref) => UserDataProvider());
final nickNameCtr = ChangeNotifierProvider((ref) => TextEditingController());
final jersyController =
    ChangeNotifierProvider((ref) => TextEditingController());

class UserDataProvider with ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;

  bool userUpdation = false;
  String _nickname = '';
  List<String> _positions = [];
  String _imageUrl = '';
  String _fullName = '';
  int _jersyNumber = 0;

  int? totalGoals;
  int? totalGames;
  double? aveGoals;
  bool isUpdation = false;

  List<Map<String, dynamic>> _postionsData = [
    {
      POSITIONS: "Forward",
      VALUE: false,
    },
    {
      POSITIONS: "Striker",
      VALUE: false,
    },
    {
      POSITIONS: "Mid Field",
      VALUE: false,
    },
    {
      POSITIONS: "Defense",
      VALUE: false,
    },
    {
      POSITIONS: "Goalie",
      VALUE: false,
    },
  ];
  List<Map<String, dynamic>> get postionsList => _postionsData;

  String userName() {
    final userName = _fullName;
    notifyListeners();
    return userName;
  }

  // Future<void> fetchUserStatsData() async {
  //   isUpdation = true;
  //   notifyListeners();
  //   try {
  //     final user = FirebaseAuth.instance.currentUser;
  //     final settingsDocRef = _firestore.collection(USERS).doc(user!.uid);

  //     // Fetch existing settings data
  //     final settingsDocSnapshot = await settingsDocRef.get();
  //     final data = settingsDocSnapshot.data();
  //     final getLocations = Map<String, dynamic>.from(data?[PLAYER_STATS] ?? []);
  //     totalGames = getLocations[TOTAL_GAMES];
  //     totalGoals = getLocations[TOTAL_GOALS];
  //     aveGoals = getLocations[AVERAGE_GOALS];

  //     notifyListeners();
  //   } catch (error) {
  //     print('Error fetching app settings: $error');
  //   }
  //   isUpdation = false;
  //   notifyListeners();
  // }

  String get nickname => _nickname;
  List<String> get positions => _positions;
  String get imageUrl => _imageUrl;
  String get fullName => _fullName;
  String get userUid => FirebaseAuth.instance.currentUser!.uid;
  int get jersyNumber => _jersyNumber;
  Future<void> checkAuthenticationStatus(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // User is logged in, navigate to HomeScreen
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, AppNavBar.screen);
      });
    } else {
      // User is not logged in, navigate to SignUpScreen
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, AuthScreen.screen);
      });
    }
    notifyListeners();
  }
//  Future<void> fetchUserData(String userId) async {
//     try {
//       // Get reference to the user document in the USERS collection
//       DocumentReference userRef =
//           FirebaseFirestore.instance.collection('USERS').doc(userId);

//       // Get the user document snapshot
//       DocumentSnapshot userSnapshot = await userRef.get();

//       // Check if the document exists
//       if (userSnapshot.exists) {
//         // Cast the result of data() to Map<String, dynamic>
//         Map<String, dynamic>? userData =
//             userSnapshot.data() as Map<String, dynamic>?;

//         if (userData != null) {
//           // Update class variables with values from user data
//           totalGames = userData['PLAYER_STATS']['TOTAL_GAMES'] ?? 0;
//           totalGoals = userData['PLAYER_STATS']['TOTAL_GOALS'] ?? 0;
//           aveGoals = userData['PLAYER_STATS']['AVE_GOALS'] ?? 0.0;
//         } else {
//           print('User data is null');
//         }
//       } else {
//         print('User document does not exist');
//       }
//     } catch (error) {
//       print('Error fetching user data: $error');
//     }
//   }

  // Fetch user data from Firestore
  Future<void> fetchUserData() async {
    try {
      print(
          "..............##############.......#######$userUid################>>>>>>>>>>>>>>");
      // Get reference to the user document in the USERS collection
      // Get reference to the user document in the USERS collection
      DocumentReference userRef =
          FirebaseFirestore.instance.collection(USERS).doc(userUid);

      // Get the user document snapshot
      DocumentSnapshot userSnapshot = await userRef.get();

      Map<String, dynamic>? userData =
          userSnapshot.data() as Map<String, dynamic>;

      if (userData != null && userData.containsKey(PLAYER_STATS)) {
        Map<String, dynamic>? playerStats = userData[PLAYER_STATS];
        // Now you can access the 'PLAYER_STATS' map safely
        if (playerStats != null) {
          // Update class variables with values from PLAYER_STATS
          totalGames = playerStats[TOTAL_GAMES].toInt() ?? 0;
          totalGoals = playerStats[TOTAL_GOALS].toInt() ?? 0;
          aveGoals = double.parse(playerStats[AVERAGE_GOALS].toString())
              .roundToDouble();
        } else {
          print('PLAYER_STATS data is null');
        }
      } else {
        print('PLAYER_STATS field not found or user data is null');
      }
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot<Map<String, dynamic>> userData =
            await FirebaseFirestore.instance
                .collection(USERS)
                .doc(user.uid)
                .get();

        if (userData.exists) {
          _nickname = userData[NICKNAME];
          _positions = List<String>.from(userData[POSITIONS]);
          _imageUrl = userData[IMAGEURL].toString();
          _fullName = userData[FULLNAME].toString();
          _jersyNumber = int.parse(userData[JERSYNUMBER].toString());

          // ScaffoldMessenger.of(context)
          //     .showSnackBar(SnackBar(content: Text("Welcome")));
          notifyListeners();
        } else {
          // ScaffoldMessenger.of(context).showSnackBar(
          //     SnackBar(content: Text("Something Wrong with your connection")));
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  // Update user profile data
  Future<void> updateUserProfile({
    required String nickname,
    required List<String> positions,
    required String imageUrl,
    // required String fullName,
    required int jersyNumber,
    required BuildContext context,
  }) async {
    try {
      userUpdation = true;
      notifyListeners();
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection(USERS)
            .doc(user.uid)
            .update({
          NICKNAME: nickname,
          POSITIONS: positions,
          // IMAGEURL: imageUrl,
          JERSYNUMBER: jersyNumber.toString()
          // FULLNAME: fullName,
        });

        // Update local data
        _nickname = nickname;
        _positions = positions;
        _imageUrl = imageUrl;
        // _fullName = fullName;
        notifyListeners();
      }
      userUpdation = false;
      Navigator.pop(context);
      notifyListeners();
    } catch (e) {
      userUpdation = false;
      notifyListeners();
      print('Error updating user profile: $e');
    }
  } // String userName() {

  void updateNickname(String newNickname) {
    _nickname = newNickname;
    notifyListeners();
  }

  void updateJerseyNumber(int newJerseyNumber) {
    _jersyNumber = newJerseyNumber;
    notifyListeners();
  }

  List<String> getSelectedPositions() {
    List<String> selectedPositions = [];
    for (var position in _postionsData) {
      if (position[VALUE]) {
        selectedPositions.add(position[POSITIONS]);
      }
    }
    notifyListeners();
    return selectedPositions;
  }

  void togglePosition(int index) {
    _postionsData[index][VALUE] = !_postionsData[index][VALUE];
    notifyListeners();
  }
}
