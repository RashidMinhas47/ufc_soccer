import 'package:flutter/material.dart';

class ProfilePicturePopup extends StatelessWidget {
  final String imageUrl;

  const ProfilePicturePopup({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetAnimationCurve: Curves.bounceInOut,
      elevation: 0,
      insetPadding: EdgeInsets.symmetric(horizontal: 16),
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          padding: const EdgeInsets.all(8.0),
          width: double.infinity,
          child: Hero(
            tag: "profileImage", // Use the same tag for the Hero animation
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
