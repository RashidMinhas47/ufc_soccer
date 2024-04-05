// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:ufc_soccer/providers/manage_app_provider.dart';
// import 'package:ufc_soccer/providers/setup_game_provider.dart';

// class ManagerWidget extends StatelessWidget {
//   const ManagerWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//       child: Consumer(
//         builder: (context, ref, child) {
//           final setGamePro = ref.watch(setupGameProvider.notifier);
//           final appSettingPro = ref.watch(appSettingsProvider);
//           final maxPlayers = setGamePro.state.maxPlayers?.toString() ?? '0';

//           return InputDecorator(
//             decoration: InputDecoration(
//               border: const OutlineInputBorder(),
//               hintText: 'Manager',
//               hintStyle: GoogleFonts.poppins(),
//             ),
//             child: DropdownButtonFormField<String>(
//               decoration: InputDecoration.collapsed(
//                 hintText: 'Manager',
//                 hintStyle: GoogleFonts.poppins(),
//               ),
//               value: maxPlayers,
//               items: appSettingPro.locations.map((String value) {
//                 return DropdownMenuItem<String>(
//                   value: value,
//                   child: Text("$value", style: GoogleFonts.poppins()),
//                 );
//               }).toList(),
//               onChanged: (String? value) {
//                 setGamePro.setManager(value!);
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
