import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_soccer/screens/app_nav_bar.dart';
import 'package:ufc_soccer/screens/auth_check_screen.dart';
import 'package:ufc_soccer/screens/home/home_screen.dart';
import 'package:ufc_soccer/utils/firebase_const.dart';
import '../utils/const_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final signInProvider = ChangeNotifierProvider((ref) => SignInProviderAuth());
final signUpProvider = ChangeNotifierProvider((ref) => SignUpAuthProvider());

class SignUpAuthProvider with ChangeNotifier {
  UserCredential? userCredential;
  String? displayName;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool loading = false;
  void signUpValidation({
    required BuildContext context,
    required TextEditingController? nameController,
    required TextEditingController? email,
    required TextEditingController? password,
    String? displayName,
    required String correctCode, // Argument representing the correct code
  }) async {
    loading = true;
    notifyListeners();

    if (nameController!.text.trim().isEmpty ||
        email!.text.isEmpty ||
        password!.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Fill all the fields"),
        ),
      );
      loading = false;
      notifyListeners();
    } else {
      try {
        loading = true;
        notifyListeners();

        // Check if the provided email matches the correct code
        if (correctCode == 'ufcsoccer@admin1') {
          userCredential = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
                  email: email.text, password: password.text);

          final String uid = userCredential!.user?.uid ?? '';
          CollectionReference userCollection = _firestore.collection(USERS);
          await userCollection.doc(uid).set({
            UID: uid,
            FULLNAME: nameController.text,
            EMAIL: email.text,
            NICKNAME: '',
            JERSYNUMBER: '',
            IMAGEURL: '',
            APPROVED: true,
            POSITIONS: [],
            // Process the account if condition is met
          });

          try {
            User? user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              await user.updateDisplayName(displayName);

              this.displayName = displayName;
              AppSnackBar.snackBar(
                  context, 'Your Account is Created go to login page');
              notifyListeners();
            }
          } catch (e) {
            print('Error updating display name: $e');
          }

          loading = false;
        } else {
          // Show message if the provided code is incorrect
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("You've provided an incorrect code."),
            ),
          );
          loading = false;
        }
      } on FirebaseException catch (e) {
        if (e.message != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.message.toString()),
            ),
          );
          loading = false;
        }
      }
    }
    notifyListeners();
  }

  // void signUpValidation({
  //   required BuildContext context,
  //   required TextEditingController? nameController,
  //   required TextEditingController? email,
  //   required TextEditingController? password,
  //   String? displayName,
  // }) async {
  //   loading = true;
  //   notifyListeners();
  //   if (nameController!.text.trim().isEmpty ||
  //       email!.text.isEmpty ||
  //       password!.text.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text("Fill all the Filed"),
  //       ),
  //     );
  //     loading = false;
  //     notifyListeners();
  //   } else {
  //     try {
  //       loading = true;
  //       notifyListeners();
  //       userCredential = await FirebaseAuth.instance
  //           .createUserWithEmailAndPassword(
  //               email: email.text, password: password.text);

  //       final String uid = userCredential!.user?.uid ?? '';
  //       CollectionReference _userCollection = _firestore.collection("users");
  //       await _userCollection.doc(uid).set({
  //         'uid': uid,
  //         "name": nameController.text,
  //         "email": email.text,
  //         "isApproved": false,
  //       });

  //       try {
  //         User? user = FirebaseAuth.instance.currentUser;
  //         if (user != null) {
  //           await user.updateDisplayName(displayName);

  //           this.displayName = displayName;
  //           AppSnackBar.snackBar(
  //               context, 'Your Account is Created go to login page');
  //           notifyListeners();
  //         }
  //       } catch (e) {
  //         print('Error updating display name: $e');
  //       }

  //       loading = false;
  //     } on FirebaseException catch (e) {
  //       if (e.message != null) {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(
  //             content: Text(e.message.toString()),
  //           ),
  //         );
  //         loading = false;
  //       }
  //     }
  //   }
  //   notifyListeners();
  // }
}

class SignInProviderAuth with ChangeNotifier {
  UserCredential? userCredential;
  bool loading = false;

  void signOutUser(BuildContext context) {
    final auth = FirebaseAuth.instance;
    auth.signOut();
    Navigator.restorablePopAndPushNamed(context, AuthCheckScreen.screen);
    notifyListeners();
  }

  void signInValidation(
      {required TextEditingController email,
      required TextEditingController password,
      String? uid,
      required BuildContext context}) async {
    loading = true;
    notifyListeners();
    if (email.text.isEmpty || password.text.isEmpty) {
      AppSnackBar.snackBar(context, "Fill all the Details");
      loading = false;
      notifyListeners();
    } else {
      try {
        loading = true;
        notifyListeners();
        userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email.text.trim(), password: password.text.trim());
        FirebaseAuth.instance.currentUser;
        final userCollection = FirebaseFirestore.instance.collection('users');
        QuerySnapshot querySnapshot =
            await userCollection.where('uid', isEqualTo: uid).get();
        Navigator.pushReplacementNamed(context, AppNavBar.screen);
        if (querySnapshot.docs.isEmpty) {
        } else if (querySnapshot.docs.isNotEmpty) {
          AppSnackBar.snackBar(context, "Welcome");
        }

        loading = false;
        notifyListeners();
        //TODO:01 I AM COMMENTING THIS FOR NOW
        // RoutingPage.gotoNextPageP(
        //     context: context, gotoNextPagep: CameraScreen());
      } on FirebaseException catch (e) {
        if (e.message != null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(e.message.toString()),
          ));
          loading = false;
          notifyListeners();
        }
      }
    }
  }
}
