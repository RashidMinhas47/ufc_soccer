import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_soccer/screens/app_nav_bar.dart';
import 'package:ufc_soccer/utils/firebase_const.dart';

final updatePlayerStatsProvider =
    ChangeNotifierProvider((ref) => UpdatePlayerStatsProvider());

class UpdatePlayerStatsProvider extends ChangeNotifier {
  bool isloading = false;
  List<String> _videoUrls = [];

  List<String> get videoUrls => _videoUrls;
  addVideoUrls(value) {
    if (!_videoUrls.contains(value)) {
      _videoUrls.add(value);
      notifyListeners();
    }
    notifyListeners();
  }

  Future<void> updateUserData(String userId,
      List<Map<String, dynamic>> userData, BuildContext context) async {
    try {
      isloading = true;
      final DocumentReference userRef =
          FirebaseFirestore.instance.collection('USERS').doc(userId);

      await userRef.update({USER_GAME_STATS: userData});
      notifyListeners();
      bool conditionToStopPopping(Route<dynamic> route) {
        // Check if the route is of type MyRoute
        return route.settings.name == AppNavBar.screen;
      }

      Navigator.popUntil(context, (route) {
        return conditionToStopPopping(route);
      });
      isloading = false;
      print('User data updated successfully.');
    } catch (error) {
      print('Error updating user data: $error');
      // Handle error accordingly
    }
  }
}
