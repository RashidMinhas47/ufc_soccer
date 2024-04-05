// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:ufc_soccer/providers/setup_game_provider.dart';

// class MaxPlayerWidget extends StatelessWidget {
//   const MaxPlayerWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//       child: Consumer(
//         builder: (context, ref, child) {
//           final setGamePro = ref.watch(setupGameProvider.notifier);
//           final maxPlayers = setGamePro.state.maxPlayers?.toString() ?? '0';

//           return InputDecorator(
//             decoration: InputDecoration(
//               border: const OutlineInputBorder(),
//               hintText: 'Max Player',
//               hintStyle: GoogleFonts.poppins(),
//             ),
//             child: DropdownButtonFormField<String>(
//               decoration: InputDecoration.collapsed(
//                 hintText: maxPlayers.isEmpty ? 'Max Player' : null,
//                 hintStyle: GoogleFonts.poppins(),
//               ),
//               value: maxPlayers,
//               items: List.generate(99, (index) => index.toString())
//                   .map((String value) {
//                 return DropdownMenuItem<String>(
//                   value: value,
//                   child: Text(
//                       int.parse(value) == 0 ? "Max Player" : "$value players",
//                       style: GoogleFonts.poppins()),
//                 );
//               }).toList(),
//               onChanged: (String? value) {
//                 setGamePro.setMaxPlayers(value!);
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
