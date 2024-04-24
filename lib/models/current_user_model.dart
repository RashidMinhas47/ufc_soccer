import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_soccer/utils/firebase_const.dart';

class UserModel {
  String fullName;
  String nickName;
  String jersyNumber;
  List<String> positions;
  String imageUrl;
  UserModel(
      {required this.fullName,
      required this.nickName,
      required this.jersyNumber,
      required this.imageUrl,
      required this.positions});
}

class UserViewModel {
  // final String userUid;
  // UserViewModel({required this.userUid});
  Stream<UserModel> getUsersStream(String userUid) {
    return FirebaseFirestore.instance
        .collection(USERS)
        .doc(userUid)
        .snapshots()
        .map((snapshot) {
      final data = snapshot.data() as Map<String, dynamic>;
      return UserModel(
        fullName: data[FULLNAME],
        nickName: data[NICKNAME],
        jersyNumber: data[JERSYNUMBER],
        positions: List<String>.from(data[POSITIONS]),
        imageUrl: data[IMAGEURL],
      );
    });
  }
}

final authNowProvider = StateProvider((ref) => FirebaseAuth.instance);

final userStreamProvider = StreamProvider<UserModel>((ref) {
  final userServices = UserViewModel();
  final userUid = ref.watch(authNowProvider).currentUser!.uid;
  return userServices.getUsersStream(userUid);
});
