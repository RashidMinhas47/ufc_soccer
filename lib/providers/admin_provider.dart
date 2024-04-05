import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/const_widgets.dart';

final adminProvider = ChangeNotifierProvider((ref) => AdminProvider());

class AdminProvider with ChangeNotifier {
  bool _loading = false;
  String? displayName;

  List<String> _adminUIDs = [];
  List<String> _adminNames = ["Ahsan I"];
  List<String> _locations = [
    "UFC Ground new york",
    'Soccer Trip silicon vally'
  ];
  //todo: i will add thosse managers and other stuff
  List<String> _managers = ["Champ", 'Ali'];

  List<String> get locations => _locations;
  List<String> get adminNames => _adminNames;
  List<String> get adminUIDs => _adminNames;
  List<String> get managers => _managers;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool get loading => _loading;
  void authenticateUser({
    required BuildContext context,
    required TextEditingController? emailController,
    required TextEditingController? passwordController,
    String? displayName,
    bool isSignUp =
        false, // Indicates if the action is for signing up or signing in
  }) async {
    try {
      // Set loading indicator
      _loading = true;
      notifyListeners();

      // Validate fields
      if (isSignUp &&
          (emailController!.text.isEmpty || passwordController!.text.isEmpty)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please fill in all fields"),
          ),
        );
        _loading = false;
        notifyListeners();
        return;
      }

      // Perform sign up if requested
      if (isSignUp) {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailController!.text,
                password: passwordController!.text);

        final String uid = userCredential.user?.uid ?? '';
        CollectionReference _userCollection = _firestore.collection("admin");
        await _userCollection.doc(uid).set({
          'uid': uid,
          "email": emailController.text,
        });

        // Update display name
        try {
          User? user = FirebaseAuth.instance.currentUser;
          if (user != null && displayName != null) {
            await user.updateDisplayName(displayName);
            this.displayName = displayName;
            AppSnackBar.snackBar(context,
                'Your account has been created. Please go to the login page');
            notifyListeners();
          }
        } catch (e) {
          print('Error updating display name: $e');
        }
      }

      // Perform sign in
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController!.text.trim(),
        password: passwordController!.text.trim(),
      );

      // Check if user is admin
      String adminUID = '35Q1ASR4JZdDeh8KhZlG0awx7222';
      if (userCredential.user != null && userCredential.user!.uid == adminUID) {
        AppSnackBar.snackBar(context, "You are Admin");
      } else {
        print("You are not autheroized");
      }

      // Hide loading indicator
      _loading = false;
    } on FirebaseException catch (e) {
      // Show error message
      if (e.message != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message.toString()),
          ),
        );
      }

      // Hide loading indicator
      _loading = false;
    }
    notifyListeners();
  }
}
