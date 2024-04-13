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

class SignUpAuthProvider extends ChangeNotifier {
  bool obScureText = true;
  bool gotoSignin = false;

  void tooglingObscureText() {
    obScureText = !obScureText;
    notifyListeners();
  }

  UserCredential? userCredential;
  String? displayName;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _loading = false;
  bool get loading => _loading;
  void signUpValidation({
    required BuildContext context,
    required TextEditingController? nameController,
    required TextEditingController? email,
    required TextEditingController? password,
    String? displayName,
    required String correctCode, // Argument representing the correct code
  }) async {
    _loading = true;
    notifyListeners();

    if (nameController!.text.trim().isEmpty ||
        email!.text.isEmpty ||
        password!.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Fill all the fields"),
        ),
      );
      _loading = false;
      notifyListeners();
    } else {
      try {
        _loading = true;
        notifyListeners();

        // Check if the provided email matches the correct code
        if (correctCode == 'ufcsoccer@admin1') {
          userCredential = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
                  email: email.text.trim(), password: password.text.trim());

          final String uid = userCredential!.user?.uid ?? '';
          CollectionReference userCollection = _firestore.collection(USERS);
          await userCollection.doc(uid).set({
            UID: uid,
            FULLNAME: nameController.text.trim(),
            EMAIL: email.text.trim(),
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
            }
          } catch (e) {
            print('Error updating display name: $e');
          }

          _loading = false;
          notifyListeners();
        } else {
          // Show message if the provided code is incorrect
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("You've provided an incorrect code."),
            ),
          );
          _loading = false;
          notifyListeners();
        }
        _loading = false;
        notifyListeners();
      } on FirebaseException catch (e) {
        if (e.message != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.message.toString()),
            ),
          );
          _loading = false;
          notifyListeners();
        }
      }
    }
    _loading = false;
    notifyListeners();
  }
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
    if (email.text.trim().isEmpty || password.text.trim().isEmpty) {
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
        final userCollection = FirebaseFirestore.instance.collection(USERS);
        QuerySnapshot querySnapshot =
            await userCollection.where(UID, isEqualTo: uid).get();
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
