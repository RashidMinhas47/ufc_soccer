import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ufc_soccer/providers/manage_app_provider.dart';
import 'package:ufc_soccer/providers/user_data.dart';
import 'package:ufc_soccer/utils/firebase_const.dart';

class UserProfileForm extends ConsumerWidget {
  // final TextEditingController? controller;

  const UserProfileForm({super.key});
  @override
  Widget build(BuildContext context, ref) {
    final editProfilePro = ref.watch(userDataProvider);
    final nickName = ref.watch(nickNameCtr);
    final jersyCtr = ref.watch(jersyController);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nickname',
            style: GoogleFonts.poppins(fontSize: 20),
          ),
          TextFormField(
            keyboardType: TextInputType.text,
            controller: nickName,
            decoration: InputDecoration(
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                ),
                hintText: 'Choose  a Nickname',
                hintStyle: GoogleFonts.poppins(fontSize: 18)),
            style: GoogleFonts.poppins(
              fontSize: 18,
            ),
          ),
          Text(
            'Jersy Number',
            style: GoogleFonts.poppins(fontSize: 20),
          ),
          TextFormField(
            controller: jersyCtr,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                ),
                hintText: 'Enter  a Jersy Number',
                hintStyle: GoogleFonts.poppins(fontSize: 18)),
            style: GoogleFonts.poppins(
              fontSize: 18,
            ),
          ),

          const Divider(),
          const SizedBox(height: 20),
          Text(
            'Positions',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          for (int i = 0; i < editProfilePro.postionsList.length; i++)
            ListTile(
              leading: Checkbox(
                value: editProfilePro.postionsList[i][VALUE],
                onChanged: (bool? value) {
                  editProfilePro.togglePosition(i);
                },
              ),
              title: Text(
                editProfilePro.postionsList[i][POSITIONS],
                style: GoogleFonts.poppins(
                  fontSize: 18,
                ),
              ),
            ),

          // ListTile(
          //   leading: Checkbox(
          //     value: false,
          //     onChanged: (bool? value) {},
          //   ),
          //   title: Text(
          //     'Striker',
          //     style: GoogleFonts.poppins(
          //       fontSize: 18,
          //     ),
          //   ),
          // ),
          // ListTile(
          //   leading: Checkbox(
          //     value: false,
          //     onChanged: (bool? value) {},
          //   ),
          //   title: Text(
          //     'Mid Field',
          //     style: GoogleFonts.poppins(
          //       fontSize: 18,
          //     ),
          //   ),
          // ),
          // ListTile(
          //   leading: Checkbox(
          //     value: false,
          //     onChanged: (bool? value) {},
          //   ),
          //   title: Text(
          //     'Defense',
          //     style: GoogleFonts.poppins(
          //       fontSize: 18,
          //     ),
          //   ),
          // ),
          // ListTile(
          //   leading: Checkbox(
          //     value: false,
          //     onChanged: (bool? value) {},
          //   ),
          //   title: Text(
          //     'Goalie',
          //     style: GoogleFonts.poppins(
          //       fontSize: 18,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:ufc_soccer/providers/user_data.dart';
// import 'package:ufc_soccer/utils/firebase_const.dart';

// class UserProfileForm extends ConsumerWidget {
//   const UserProfileForm({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Consumer(
//       builder: (context, ref, child) {
//         final userData = ref.watch(userDataProvider.notifier);
//         final nickName = ref.watch(nickNameCtr);
//         final jersyCtr = ref.watch(jersyController);

//         return Container(
//           margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Nickname',
//                 style: GoogleFonts.poppins(fontSize: 20),
//               ),
//               TextFormField(
//                 keyboardType: TextInputType.text,
//                 controller: nickName,
//                 decoration: InputDecoration(
//                   border: const OutlineInputBorder(
//                     borderRadius: BorderRadius.zero,
//                   ),
//                   hintText: 'Choose a Nickname',
//                   hintStyle: GoogleFonts.poppins(fontSize: 18),
//                 ),
//                 style: GoogleFonts.poppins(fontSize: 18),
//                 onChanged: (value) => userData.updateNickname(value),
//               ),
//               Text(
//                 'Jersey Number',
//                 style: GoogleFonts.poppins(fontSize: 20),
//               ),
//               TextFormField(
//                 controller: jersyCtr,
//                 keyboardType: TextInputType.number,
//                 decoration: InputDecoration(
//                   border: const OutlineInputBorder(
//                     borderRadius: BorderRadius.zero,
//                   ),
//                   hintText: 'Enter a Jersey Number',
//                   hintStyle: GoogleFonts.poppins(fontSize: 18),
//                 ),
//                 style: GoogleFonts.poppins(fontSize: 18),
//                 onChanged: (value) =>
//                     userData.updateJerseyNumber(int.tryParse(value) ?? 0),
//               ),
//               const Divider(),
//               const SizedBox(height: 20),
//               Text(
//                 'Positions',
//                 style: GoogleFonts.poppins(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               ListView.builder(
//                 shrinkWrap: true,
//                 itemCount: userData.state.positionsList.length,
//                 itemBuilder: (context, index) {
//                   return ListTile(
//                     leading: Checkbox(
//                       value: userData.state.positionsList[index][VALUE],
//                       onChanged: (bool? value) {
//                         userData.togglePosition(index);
//                       },
//                     ),
//                     title: Text(
//                       userData.state.positionsList[index][POSITIONS],
//                       style: GoogleFonts.poppins(fontSize: 18),
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
