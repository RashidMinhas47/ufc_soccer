import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_soccer/screens/app_nav_bar.dart';
import 'package:ufc_soccer/screens/authentication_screen.dart';
import 'package:ufc_soccer/utils/firebase_const.dart';

final userDataProvider = ChangeNotifierProvider.autoDispose((ref) {
  final provider = UserDataProvider();
  // Call fetchUserData() directly if needed for initial data
  // provider.fetchUserData(); // Uncomment if necessary
  provider.fetchUserData();
  return provider;
});

// final userDataProvider = ChangeNotifierProvider((ref) => UserDataProvider());
final nickNameCtr = ChangeNotifierProvider((ref) => TextEditingController());
final jersyController =
    ChangeNotifierProvider((ref) => TextEditingController());

class UserDataProvider with ChangeNotifier {
  UserDataProvider() {
    fetchUserData();
  }
  bool userUpdation = false;
  String _nickname = '';
  List<String> _positions = [];
  String _imageUrl = '';
  String _fullName = '';
  int _jersyNumber = 0;

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

  // Fetch user data from Firestore
  Future<void> fetchUserData() async {
    try {
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

  // void updateProfile() async {
  //   try {
  //     // Update user data in Firestore
  //     await _cloudFirestore
  //         .collection(USERS)
  //         .doc(_auth.currentUser!.uid)
  //         .update({
  //       NICKNAME: nickname,
  //       JERSYNUMBER: _jersyNumber,
  //       POSITIONS: getSelectedPositions(),
  //     });
  //     print('User data updated successfully!');
  //   } catch (error) {
  //     print('Error updating user data: $error');
  //   }
  // }
}
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:ufc_soccer/screens/app_nav_bar.dart';
// import 'package:ufc_soccer/screens/authentication_screen.dart';
// import 'package:ufc_soccer/utils/firebase_const.dart';

// final nickNameCtr = ChangeNotifierProvider((ref) => TextEditingController());
// final jersyController =
//     ChangeNotifierProvider((ref) => TextEditingController());

// final userDataProvider =
//     StateNotifierProvider((ref) => UserDataProviderNotifier());

// class UserDataProviderNotifier extends StateNotifier<UserData> {
//   UserDataProviderNotifier() : super(UserData());

//   void fetchUserData(BuildContext context) async {
//     try {
//       User? user = FirebaseAuth.instance.currentUser;
//       if (user != null) {
//         DocumentSnapshot<Map<String, dynamic>> userData =
//             await FirebaseFirestore.instance
//                 .collection(USERS)
//                 .doc(user.uid)
//                 .get();
//         if (userData.exists) {
//           state = UserData.fromMap(userData.data()!);
//         } else {
//           // Handle the case where user data does not exist
//         }
//       }
//     } catch (e) {
//       print('Error fetching user data: $e');
//     }
//   }

//   void updateUserProfile({
//     required String nickname,
//     required List<String> positions,
//     required String imageUrl,
//     required int jersyNumber,
//     required BuildContext context,
//   }) async {
//     try {
//       state = state.copyWith(
//         nickname: nickname,
//         positions: positions,
//         imageUrl: imageUrl,
//         jersyNumber: jersyNumber,
//       );

//       User? user = FirebaseAuth.instance.currentUser;
//       if (user != null) {
//         await FirebaseFirestore.instance
//             .collection(USERS)
//             .doc(user.uid)
//             .update({
//           NICKNAME: nickname,
//           POSITIONS: positions,
//           JERSYNUMBER: jersyNumber,
//         });
//       }
//       Navigator.pop(context);
//     } catch (e) {
//       print('Error updating user profile: $e');
//     }
//   }

//   void updateNickname(String newNickname) {
//     state = state.copyWith(nickname: newNickname);
//   }

//   void updateJerseyNumber(int newJerseyNumber) {
//     state = state.copyWith(jersyNumber: newJerseyNumber);
//   }

//   void togglePosition(int index) {
//     final List<Map<String, dynamic>> updatedPositions = [
//       ...state.positionsList
//     ];
//     updatedPositions[index][VALUE] = !updatedPositions[index][VALUE];
//     state = state.copyWith(positionsList: updatedPositions);
//   }
// }

// class UserData {
//   UserData({
//     this.userUpdation = false,
//     this.nickname = '',
//     this.positions = const [],
//     this.imageUrl = '',
//     this.fullName = '',
//     this.jersyNumber = 0,
//     this.positionsList = const [
//       {POSITIONS: "Forward", VALUE: false},
//       {POSITIONS: "Striker", VALUE: false},
//       {POSITIONS: "Mid Field", VALUE: false},
//       {POSITIONS: "Defense", VALUE: false},
//       {POSITIONS: "Goalie", VALUE: false},
//     ],
//   });

//   final bool userUpdation;
//   final String nickname;
//   final List<String> positions;
//   final String imageUrl;
//   final String fullName;
//   final int jersyNumber;
//   final List<Map<String, dynamic>> positionsList;

//   UserData copyWith({
//     bool? userUpdation,
//     String? nickname,
//     List<String>? positions,
//     String? imageUrl,
//     String? fullName,
//     int? jersyNumber,
//     List<Map<String, dynamic>>? positionsList,
//   }) {
//     return UserData(
//       userUpdation: userUpdation ?? this.userUpdation,
//       nickname: nickname ?? this.nickname,
//       positions: positions ?? this.positions,
//       imageUrl: imageUrl ?? this.imageUrl,
//       fullName: fullName ?? this.fullName,
//       jersyNumber: jersyNumber ?? this.jersyNumber,
//       positionsList: positionsList ?? this.positionsList,
//     );
//   }

//   factory UserData.fromMap(Map<String, dynamic> map) {
//     return UserData(
//       userUpdation: false,
//       nickname: map[NICKNAME] ?? '',
//       positions: List<String>.from(map[POSITIONS] ?? []),
//       imageUrl: map[IMAGEURL] ?? '',
//       fullName: map[FULLNAME] ?? '',
//       jersyNumber: map[JERSYNUMBER] ?? 0,
//     );
//   }
// }

// // class UserData {
// //   UserData({
// //     this.userUpdation = false,
// //     this.nickname = '',
// //     this.positions = const [],
// //     this.imageUrl = '',
// //     this.fullName = '',
// //     this.jersyNumber = 0,
// //     this.positionsList = const [
// //       {POSITIONS: "Forward", VALUE: false},
// //       {POSITIONS: "Striker", VALUE: false},
// //       {POSITIONS: "Mid Field", VALUE: false},
// //       {POSITIONS: "Defense", VALUE: false},
// //       {POSITIONS: "Goalie", VALUE: false},
// //     ],
// //   });

// //   final bool userUpdation;
// //   final String nickname;
// //   final List<String> positions;
// //   final String imageUrl;
// //   final String fullName;
// //   final int jersyNumber;
// //   final List<Map<String, dynamic>> positionsList;

// //   UserData copyWith({
// //     bool? userUpdation,
// //     String? nickname,
// //     List<String>? positions,
// //     String? imageUrl,
// //     String? fullName,
// //     int? jersyNumber,
// //     List<Map<String, dynamic>>? positionsList,
// //   }) {
// //     return UserData(
// //       userUpdation: userUpdation ?? this.userUpdation,
// //       nickname: nickname ?? this.nickname,
// //       positions: positions ?? this.positions,
// //       imageUrl: imageUrl ?? this.imageUrl,
// //       fullName: fullName ?? this.fullName,
// //       jersyNumber: jersyNumber ?? this.jersyNumber,
// //       positionsList: positionsList ?? this.positionsList,
// //     );
// //   }

// //   factory UserData.fromMap(Map<String, dynamic> map) {
// //     return UserData(
// //       userUpdation: false,
// //       nickname: map[NICKNAME] ?? '',
// //       positions: List<String>.from(map[POSITIONS] ?? []),
// //       imageUrl: map[IMAGEURL] ?? '',
// //       fullName: map[FULLNAME] ?? '',
// //       jersyNumber: map[JERSYNUMBER] ?? 0,
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:ufc_soccer/utils/firebase_const.dart';

// final userDataProvider =
//     StateNotifierProvider<UserDataProviderNotifier, UserData>((ref) {
//   return UserDataProviderNotifier();
// });

// final nickNameCtr = Provider((ref) => TextEditingController());
// final jersyController = Provider((ref) => TextEditingController());

// class UserDataProviderNotifier extends StateNotifier<UserData> {
//   UserDataProviderNotifier() : super(UserData());

//   void fetchUserData(BuildContext context) async {
//     try {
//       User? user = FirebaseAuth.instance.currentUser;
//       if (user != null) {
//         DocumentSnapshot<Map<String, dynamic>> userData =
//             await FirebaseFirestore.instance
//                 .collection(USERS)
//                 .doc(user.uid)
//                 .get();
//         if (userData.exists) {
//           state = UserData.fromMap(userData.data()!);
//         } else {
//           // Handle the case where user data does not exist
//         }
//       }
//     } catch (e) {
//       print('Error fetching user data: $e');
//     }
//   }

//   void updateUserProfile({
//     required String nickname,
//     required List<String> positions,
//     required String imageUrl,
//     required int jersyNumber,
//     required BuildContext context,
//   }) async {
//     try {
//       state = state.copyWith(
//         nickname: nickname,
//         positions: positions,
//         imageUrl: imageUrl,
//         jersyNumber: jersyNumber,
//       );

//       User? user = FirebaseAuth.instance.currentUser;
//       if (user != null) {
//         await FirebaseFirestore.instance
//             .collection(USERS)
//             .doc(user.uid)
//             .update({
//           NICKNAME: nickname,
//           POSITIONS: positions,
//           JERSYNUMBER: jersyNumber,
//         });
//       }
//       Navigator.pop(context);
//     } catch (e) {
//       print('Error updating user profile: $e');
//     }
//   }

//   void updateNickname(String newNickname) {
//     state = state.copyWith(nickname: newNickname);
//   }

//   void updateJerseyNumber(int newJerseyNumber) {
//     state = state.copyWith(jersyNumber: newJerseyNumber);
//   }

//   void togglePosition(int index) {
//     final List<Map<String, dynamic>> updatedPositions = [
//       ...state.positionsList
//     ];
//     updatedPositions[index][VALUE] = !updatedPositions[index][VALUE];
//     state = state.copyWith(positionsList: updatedPositions);
//   }
// }

// class UserData {
//   UserData({
//     this.userUpdation = false,
//     this.nickname = '',
//     this.userUid = '',
//     this.positions = const [],
//     this.imageUrl = '',
//     this.fullName = '',
//     this.jersyNumber = 0,
//     this.positionsList = const [
//       {POSITIONS: "Forward", VALUE: false},
//       {POSITIONS: "Striker", VALUE: false},
//       {POSITIONS: "Mid Field", VALUE: false},
//       {POSITIONS: "Defense", VALUE: false},
//       {POSITIONS: "Goalie", VALUE: false},
//     ],
//   });

//   final bool userUpdation;
//   final String userUid;
//   final String nickname;
//   final List<String> positions;
//   final String imageUrl;
//   final String fullName;
//   final int jersyNumber;
//   final List<Map<String, dynamic>> positionsList;

//   UserData copyWith({
//     bool? userUpdation,
//     String? userUid,
//     String? nickname,
//     List<String>? positions,
//     String? imageUrl,
//     String? fullName,
//     int? jersyNumber,
//     List<Map<String, dynamic>>? positionsList,
//   }) {
//     return UserData(
//       userUpdation: userUpdation ?? this.userUpdation,
//       userUid: userUid ?? this.userUid,
//       nickname: nickname ?? this.nickname,
//       positions: positions ?? this.positions,
//       imageUrl: imageUrl ?? this.imageUrl,
//       fullName: fullName ?? this.fullName,
//       jersyNumber: jersyNumber ?? this.jersyNumber,
//       positionsList: positionsList ?? this.positionsList,
//     );
//   }

//   factory UserData.fromMap(Map<String, dynamic> map) {
//     return UserData(
//       userUpdation: false,
//       userUid: map[UID],
//       nickname: map[NICKNAME] ?? '',
//       positions: List<String>.from(map[POSITIONS] ?? []),
//       imageUrl: map[IMAGEURL] ?? '',
//       fullName: map[FULLNAME] ?? '',
//       jersyNumber: map[JERSYNUMBER] ?? 0,
//     );
//   }
// }
