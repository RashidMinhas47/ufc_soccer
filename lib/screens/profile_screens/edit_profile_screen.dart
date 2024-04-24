import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ufc_soccer/models/current_user_model.dart';
import 'package:ufc_soccer/providers/user_data.dart';
import 'package:ufc_soccer/screens/home/pages/join_&_leave_game.dart';
import 'package:ufc_soccer/utils/constants.dart';
import 'package:ufc_soccer/widgets/custom_large_btn.dart';

import 'package:ufc_soccer/widgets/user_card.dart';
import 'package:ufc_soccer/widgets/user_profile_form.dart';

class EditProfileScreen extends ConsumerWidget {
  static const String screen = '/EditProfileScreen';
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final size = MediaQuery.of(context).size;
    final editProfilePro = ref.watch(userDataProvider);
    final jersyCtr = ref.watch(jersyController);
    final nickName = ref.watch(nickNameCtr);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          "Edit Profile",
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        centerTitle: true,
      ),
      body: editProfilePro.userUpdation
          ? prograssWidget
          : SingleChildScrollView(
              child: Column(
                children: [
                  UserProfileCardWithoutAction(
                    label:
                        "${editProfilePro.userName()}[${editProfilePro.jersyNumber.toString()}]",
                    subtitle: ref.read(userDataProvider).nickname,
                    subtitle2: ref.read(userDataProvider).positions.join(', '),
                  ),
                  const UserProfileForm(),
                  LargeFlatButton(
                    backgroundColor: kPrimaryColor,
                    size: size,
                    onPressed: () {
                      if (nickName.text != null ||
                          nickName.text.isNotEmpty && jersyCtr.text != null ||
                          jersyCtr.text.isNotEmpty) {
                        editProfilePro.updateNickname(nickName.text);
                        editProfilePro
                            .updateJerseyNumber(int.parse(jersyCtr.text));
                        editProfilePro.updateUserProfile(
                          context: context,
                          nickname: editProfilePro.nickname,
                          jersyNumber: int.parse(jersyCtr.text),
                          positions: editProfilePro.getSelectedPositions(),
                          imageUrl: '',
                        );
                      }

                      // editProfilePro.updateJerseyNumber(newJerseyNumber)
                    },
                    label: 'Update',
                    fontColor: kWhiteColor,
                  )
                ],
              ),
            ),
    );
  }
}

const prograssWidget = Center(
  child: CircularProgressIndicator(),
);

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:ufc_soccer/providers/user_data.dart';
// import 'package:ufc_soccer/utils/constants.dart';
// import 'package:ufc_soccer/widgets/custom_large_btn.dart';
// import 'package:ufc_soccer/widgets/user_card.dart';
// import 'package:ufc_soccer/widgets/user_profile_form.dart';

// class EditProfileScreen extends ConsumerWidget {
//   static const String screen = '/EditProfileScreen';

//   const EditProfileScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final size = MediaQuery.of(context).size;
//     final editProfilePro = ref.watch(userDataProvider.notifier);
//     final jersyCtr = ref.watch(jersyController);
//     final nickName = ref.watch(nickNameCtr);

//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       appBar: AppBar(
//         title: Text(
//           "Edit Profile",
//           style: GoogleFonts.inter(
//             fontWeight: FontWeight.bold,
//             fontSize: 30,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: ref.watch(userDataProvider.notifier).state.userUpdation
//           ? progressWidget
//           : SingleChildScrollView(
//               child: Column(
//                 children: [
//                   UserProfileCardWithoutAction(
//                     label:
//                         "${ref.watch(userDataProvider.notifier).state.fullName}[${ref.watch(userDataProvider.notifier).state.jersyNumber}]",
//                     subtitle:
//                         ref.watch(userDataProvider.notifier).state.nickname,
//                     subtitle2: ref
//                         .watch(userDataProvider.notifier)
//                         .state
//                         .positions
//                         .join(', '),
//                   ),
//                   const UserProfileForm(),
//                   LargeFlatButton(
//                     backgroundColor: kPrimaryColor,
//                     size: size,
//                     onPressed: () {
//                       if (nickName.text.isNotEmpty &&
//                           jersyCtr.text.isNotEmpty) {
//                         editProfilePro.updateNickname(nickName.text);
//                         editProfilePro
//                             .updateJerseyNumber(int.parse(jersyCtr.text));
//                         editProfilePro.updateUserProfile(
//                           context: context,
//                           nickname: editProfilePro.state.nickname,
//                           jersyNumber: int.parse(jersyCtr.text),
//                           positions: editProfilePro.state.positions,
//                           imageUrl: '',
//                         );
//                       }
//                     },
//                     label: 'Update',
//                     fontColor: kWhiteColor,
//                   ),
//                 ],
//               ),
//             ),
//     );
//   }
// }

// const progressWidget = Center(
//   child: CircularProgressIndicator(),
// );
