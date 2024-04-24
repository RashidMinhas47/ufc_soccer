import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_soccer/screens/app_nav_bar.dart';
import 'package:ufc_soccer/utils/firebase_const.dart';
import 'package:firebase_database/firebase_database.dart';

final appSettingsProvider =
    ChangeNotifierProvider((ref) => AppSettingsProvider());

class AppSettingsProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  AppSettingsProvider() {
    fetchSettingsData();
  }
  List<String> _locations = [];
  List<String> _managers = [];
  String? _selectedLocation;
  String? _selectedManager;

  // List<String> _availableLocations = [];

  List<String> get locations => _locations;
  // FirebaseFirestore get firebaseFirestore => _firestore;
  List<String> get managers => _managers;

  // List<String> get availableLocations => _availableLocations;
  String appAccessCode = '';
  bool isUpdation = false;
  String? get selectedLocation => _selectedLocation;
  String? get selectedManager => _selectedManager;

  void selectLocation(value) {
    _selectedLocation = value;
    notifyListeners();
  }

  void selectManager(value) {
    _selectedManager = value;
    notifyListeners();
  }

  void addLocation(String location) async {
    // if (!locations.contains(location)) {
    if (!_locations.contains(location)) {
      _locations.add(location);
      print(_locations);

      notifyListeners();
    }
    // } else {
    // }
    notifyListeners();
  }

  void addManager(String manager) async {
    if (!_managers.contains(manager)) {
      _managers.add(manager);
      print("You Have GOt the list $_managers");
      notifyListeners();
    } else {
      print("You Have Error the list $_managers");
    }
    notifyListeners();
  }

  Future<void> updateAppAccessCode(String accessCode) async {
    appAccessCode = accessCode;
    notifyListeners();
  }

  Future<void> fetchSettingsData() async {
    isUpdation = true;
    notifyListeners();
    try {
      final settingsDocRef = _firestore.collection(APPSETTINGS).doc(SETTINGS);

      // Fetch existing settings data
      final settingsDocSnapshot = await settingsDocRef.get();
      final data = settingsDocSnapshot.data();
      final getLocations = List<String>.from(data?[LOCATIONS] ?? []);
      final getManagers = List<String>.from(data?[MANAGERS] ?? []);
      _locations = getLocations;
      _managers = getManagers;
      notifyListeners();
    } catch (error) {
      print('Error fetching app settings: $error');
    }
    isUpdation = false;
    notifyListeners();
  }

  Future<void> updateAppSettings(BuildContext context) async {
    try {
      // _locations.addAll();
      final settingsDoc = _firestore.collection(APPSETTINGS).doc(SETTINGS);

      // Check if the settings document exists
      final settingsSnapshot = await settingsDoc.get();
      if (!settingsSnapshot.exists) {
        // Create the settings document if it doesn't exist
        await settingsDoc.set({});
      }

      // Update locations if not empty
      if (_locations.isNotEmpty) {
        print(_locations);
        await settingsDoc.update({
          LOCATIONS: _locations,
        });
      }

      // Update managers if not empty
      if (managers.isNotEmpty) {
        await settingsDoc.update({
          MANAGERS: _managers,
        });
      }

      // Update app access code if not empty
      if (appAccessCode.isNotEmpty) {
        setAppAccessCode(appAccessCode);
        await settingsDoc.update({
          APPACCESSCODE: appAccessCode,
        });
      }
      bool conditionToStopPopping(Route<dynamic> route) {
        // Check if the route is of type MyRoute
        return route.settings.name == AppNavBar.screen;
      }

      // Navigator.popUntil(context, (route) {
      //   return conditionToStopPopping(route);
      // });
      Navigator.of(context).popUntil((route) => route.isFirst);
      print('App settings updated successfully!');
    } catch (error) {
      print('Error updating app settings: $error');
    }
  }

  String appCode = '';
  Future<String?> getAppAccessCode() async {
    DatabaseReference reference =
        FirebaseDatabase.instance.ref().child(APPACCESSCODE);

    try {
      // Retrieve the value of the appAccessCode variable
      final snapshot = await reference.get();

      // Extract the value from the snapshot
      String? accessCode = snapshot.value.toString();
      appCode = accessCode;
      return accessCode;
    } catch (e) {
      print('Error fetching app access code: $e');
      return null;
    }
  }

  // Future<String?> getAppAccessCode() async {
  //   DatabaseReference reference = FirebaseDatabase.instance.reference();

  //   // Retrieve the value of the appAccessCode variable
  //   DataSnapshot snapshot = reference.child(APPACCESSCODE).once();

  //   // Extract the value from the snapshot
  //   String? accessCode = snapshot.value;

  //   return accessCode;
  // }

  void setAppAccessCode(String accessCode) {
    try {
      DatabaseReference reference = FirebaseDatabase.instance.ref();
      reference.child(APPACCESSCODE).set(accessCode);

      print(
          "...............##########>>>>>>>>>#######..........$getAppAccessCode().............######<<<<<<<<<#######");
    } catch (e) {}
  }
}

class AppCode {
  String code;
  AppCode({required this.code});
}
