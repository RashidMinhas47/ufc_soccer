import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ufc_soccer/providers/manage_app_provider.dart';
import 'package:ufc_soccer/providers/user_data.dart';
import 'package:ufc_soccer/screens/profile_screens/edit_profile_screen.dart';
import 'package:ufc_soccer/screens/profile_screens/widgets/profile_pic_popup_widget.dart';
import 'package:ufc_soccer/screens/profile_screens/widgets/user_profile_picture.dart';
import 'package:ufc_soccer/utils/constants.dart';
import 'package:ufc_soccer/utils/image_urls.dart';

class UserProfileCard extends StatelessWidget {
  const UserProfileCard(
      {super.key,
      required this.label,
      required this.subtitle,
      this.image,
      required this.subtitle2});
  final String label;
  final String subtitle;
  final String subtitle2;
  final String? image;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: image!.isEmpty
          ? CircleAvatar(
              radius: 40,
              child: Icon(
                Icons.person,
                size: 29,
              ))
          : GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => ProfilePicturePopup(
                    imageUrl: image!,
                  ),
                );
              },
              child: Hero(
                tag: "profileImage",
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: image != null
                      ? NetworkImage(image!)
                      : const AssetImage(AppImages.appIcon) as ImageProvider,
                ),
              ),
            ),
      title: Text(
        label.toUpperCase(),
        style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Call me: ",
                  style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: kBlackColor),
                ),
                TextSpan(
                  text: subtitle,
                  style: GoogleFonts.poppins(fontSize: 14, color: kBlackColor),
                ),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Positions: ",
                  style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: kBlackColor),
                ),
                TextSpan(
                  text: subtitle2,
                  style: GoogleFonts.poppins(fontSize: 14, color: kBlackColor),
                ),
              ],
            ),
          ),
        ],
      ),
      trailing: IconButton(
          onPressed: () =>
              Navigator.pushNamed(context, EditProfileScreen.screen),
          icon: Icon(Icons.edit),
          color: Colors.black),
    );
  }
}

class UserProfileCardWithoutAction extends StatelessWidget {
  const UserProfileCardWithoutAction(
      {super.key,
      required this.label,
      required this.subtitle,
      required this.subtitle2});
  final String label;
  final String subtitle;
  final String subtitle2;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ProfilePictureUploadWidget(),
      title: Text(
        label.toUpperCase(),
        style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Call me: ",
                  style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: kBlackColor),
                ),
                TextSpan(
                  text: subtitle,
                  style: GoogleFonts.poppins(fontSize: 14, color: kBlackColor),
                ),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Positions: ",
                  style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: kBlackColor),
                ),
                TextSpan(
                  text: subtitle2,
                  style: GoogleFonts.poppins(fontSize: 14, color: kBlackColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// class UserProfileCardWithoutAction extends ConsumerWidget {
//   const UserProfileCardWithoutAction({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context, ref) {
//     final userDataPro = ref.watch(userDataProvider);

//     return ListTile(
//       leading: CircleAvatar(child: SvgPicture.asset(AppSvg.userIcon)),
//       title: Text(
//         "${userDataPro.fullName}[${userDataPro.jersyNumber}]",
//         style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
//       ),
//       subtitle: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           RichText(
//             text: TextSpan(
//               children: [
//                 TextSpan(
//                   text: "Call me: ",
//                   style: GoogleFonts.poppins(
//                       fontSize: 14, fontWeight: FontWeight.bold),
//                 ),
//                 TextSpan(
//                   text: userDataPro.nickname,
//                   style: GoogleFonts.poppins(fontSize: 20),
//                 ),
//               ],
//             ),
//           ),
//           Text(
//             "${userDataPro.getSelectedPositions().join(', ')}",
//             style: GoogleFonts.poppins(
//               fontSize: 14,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
