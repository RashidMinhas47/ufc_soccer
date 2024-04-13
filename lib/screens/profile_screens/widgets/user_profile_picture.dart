import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ufc_soccer/providers/user_data.dart';
import 'package:ufc_soccer/utils/firebase_const.dart';
import 'package:ufc_soccer/utils/image_urls.dart';
import 'package:image/image.dart' as img;

class ProfilePictureUploadWidget extends StatefulWidget {
  const ProfilePictureUploadWidget({super.key});

  @override
  State<ProfilePictureUploadWidget> createState() =>
      _ProfilePictureUploadWidgetState();
}

class _ProfilePictureUploadWidgetState
    extends State<ProfilePictureUploadWidget> {
  File? _image;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final userData = ref.watch(userDataProvider);
      return GestureDetector(
        onTap: () {
          _showImagePickerOptions(context);
        },
        child: userData.imageUrl.isEmpty
            ? CircleAvatar(
                child: Icon(
                  Icons.person,
                  size: 29,
                ),
                radius: 40)
            : CircleAvatar(
                radius: 40,
                backgroundImage: userData.imageUrl.isNotEmpty
                    ? NetworkImage(userData.imageUrl)
                    : _image != null
                        ? FileImage(_image!)
                        : AssetImage(AppImages.appIcon) as ImageProvider,
              ),
      );
    });
  }

  Future<void> _showImagePickerOptions(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Take a Photo'),
              onTap: () async {
                Navigator.pop(context);
                await _getImageFromCamera();
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Choose from Gallery'),
              onTap: () async {
                Navigator.pop(context);
                await _getImageFromGallery();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      await _uploadImageToFirebase();
    }
  }

  Future<void> _getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      await _uploadImageToFirebase();
    }
  }

// Future<File> _compressImage(File image) async {
//     // You can adjust the compression quality as needed
//     final compressedImage = await FlutterImageCompress.compressAndGetFile(
//       image.path,
//       image.path, // Destination path (overwrite original image)
//       quality: 50, // Compression quality (0 to 100)
//     );
//     return compressedImage!;
//   }
  Future<File> _compressImage(File image) async {
    final bytes = await image.readAsBytes();
    final img.Image originalImage = img.decodeImage(bytes)!;

    // You can adjust the quality as needed (0 to 100)
    final compressedImage = img.encodeJpg(originalImage, quality: 50);

    // Create a File from the compressed image bytes
    final compressedFile = File('${image.path}.compressed.jpg');
    await compressedFile.writeAsBytes(compressedImage);

    return compressedFile;
  }

  Future<void> _uploadImageToFirebase() async {
    if (_image == null) return;

    try {
      // Compress the image
      final compressedImage = await _compressImage(_image!);
      // Upload image to Firebase storage
      final firebase_storage.Reference ref = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child(PROFILE_IMAGES)
          .child('${FirebaseAuth.instance.currentUser!.uid}.jpg');

      await ref.putFile(compressedImage);

      // Get download URL of the uploaded image
      final String downloadURL = await ref.getDownloadURL();

      // Save the download URL to Firestore
      await FirebaseFirestore.instance
          .collection(USERS)
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({IMAGEURL: downloadURL}, SetOptions(merge: true));
    } catch (error) {
      print('Error uploading image to Firebase: $error');
    }
  }
}
