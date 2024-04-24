import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthUserModel {
  final String? email;
  final String? uid;
  AuthUserModel({this.email, this.uid});
}

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthUserModel? getCurrentUser() {
    final user = _auth.currentUser;
    if (user != null) {
      return AuthUserModel(uid: user.uid, email: user.email);
    }
    return null;
  }

  Stream<AuthUserModel?> authStateChanges() {
    return _auth.authStateChanges().map((user) {
      if (user != null) {
        return AuthUserModel(uid: user.uid, email: user.email);
      }
      return null;
    });
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}

final authProvider = Provider<AuthService>((ref) => AuthService());

final currentUserProvider = StreamProvider<AuthUserModel?>((ref) {
  final authService = ref.watch(authProvider);
  return authService.authStateChanges();
});

final signOutUser = StateProvider((ref) {
  final authService = ref.watch(authProvider);
  return authService.signOut();
});
