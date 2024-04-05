// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:ufc_soccer/providers/date_time_provider.dart';

// class GameSetupScreen extends ConsumerWidget {
//   static const String screen = "/GameSetupScreen";

//   @override
//   Widget build(BuildContext context, ref) {
//     final dateTimePro = ref.watch(dateTimeProvider);
//     final selectedDate = dateTimePro.selectedDate;
//     final selectedTime = dateTimePro.selectedTime;

//     return Scaffold(
//       body: Padding(
//         padding: EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             _buildDateTimeButton(
//               label: selectedDate == null
//                   ? 'Select Date'
//                   : '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
//               onPressed: () => _selectDate(context, dateTimePro),
//             ),
//             SizedBox(height: 10),
//             _buildTimeButton(
//               label: selectedTime == null
//                   ? 'Select Time'
//                   : '${selectedTime.format(context)} ${selectedTime.period.name.toUpperCase()}',
//               onPressed: () => _selectTime(context, dateTimePro),
//             ),
//             // Repeat the same pattern for other buttons
//             ElevatedButton(
//               onPressed: () {},
//               child: Text('Enter Remix Time Countdown',
//                   style: GoogleFonts.poppins()),
//             ),
//             ElevatedButton(
//               onPressed: () {},
//               child: Text('Setup Game', style: GoogleFonts.poppins()),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDateTimeButton(
//       {required String label, required VoidCallback onPressed}) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//       child: TextButton(
//         onPressed: () {
//           onPressed(); // Wrap onPressed callback in a function
//         },
//         style: ButtonStyle(
//           backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
//           padding:
//               MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.all(15)),
//           shape: MaterialStateProperty.all<OutlinedBorder>(
//             RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(10.0),
//               side: BorderSide(color: Colors.black),
//             ),
//           ),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               label,
//               style: GoogleFonts.poppins(),
//             ),
//             Icon(Icons.access_time),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTimeButton(
//       {required String label, required VoidCallback onPressed}) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//       child: TextButton(
//         onPressed: () {
//           onPressed(); // Wrap onPressed callback in a function
//         },
//         style: ButtonStyle(
//           backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
//           padding:
//               MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.all(15)),
//           shape: MaterialStateProperty.all<OutlinedBorder>(
//             RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(10.0),
//               side: BorderSide(color: Colors.black),
//             ),
//           ),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               label,
//               style: GoogleFonts.poppins(),
//             ),
//             Icon(Icons.access_time),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _selectDate(
//       BuildContext context, DateTimeProvider dateTimeProvider) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: dateTimeProvider.selectedDate ?? DateTime.now(),
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2101),
//     );
//     if (picked != null) {
//       dateTimeProvider.setDate(picked);
//     }
//   }

//   Future<void> _selectTime(
//       BuildContext context, DateTimeProvider dateTimeProvider) async {
//     final TimeOfDay? picked = await showTimePicker(
//       context: context,
//       initialTime: dateTimeProvider.selectedTime ?? TimeOfDay.now(),
//     );
//     if (picked != null) {
//       dateTimeProvider.setTime(picked);
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ufc_soccer/providers/date_time_provider.dart';

class DateTimeButtons extends ConsumerWidget {
  static const String routeName = "/GameSetupScreen";
  final String date, time;

  const DateTimeButtons({super.key, required this.date, required this.time});
  @override
  Widget build(BuildContext context, ref) {
    final dateTime = ref.watch(dateTimeProvider);

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildDateTimeButton(
            icon: Icons.calendar_month,
            label: date,
            onPressed: () => _selectDate(context, ref.read(dateTimeProvider)),
          ),
          const SizedBox(height: 10),
          _buildDateTimeButton(
            icon: Icons.access_time,
            label: time,
            onPressed: () => _selectTime(context, ref.read(dateTimeProvider)),
          ),
        ],
      ),
    );
  }

  Widget _buildDateTimeButton(
          {required String label,
          required VoidCallback onPressed,
          required IconData icon}) =>
      TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: Colors.white,
          padding: const EdgeInsets.all(15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: const BorderSide(color: Colors.black),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: GoogleFonts.poppins()),
            Icon(icon),
          ],
        ),
      );

  Future<void> _selectDate(BuildContext context, DateTimeProvider ref) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: ref.selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      ref.setDate(picked);
    }
  }

  Future<void> _selectTime(BuildContext context, DateTimeProvider ref) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: ref.selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      ref.setTime(picked);
    }
  }

  // String formattedTime(currentTimeOfDay) {

  // }
}

// Extension methods for cleaner date/time formatting (optional)
extension DateTimeFormatting on DateTime {
  String get formattedDate => "$day/$month/$year";
  // String get timeOfDay {
  //   TimeOfDay.fromDateTime(currentTimeOfDay);
  //   final hours = timeOfDay.hour.toString().padLeft(2, '0');
  //   final minutes = timeOfDay.minute.toString().padLeft(2, '0');
  //   final timePeriod = timeOfDay.period.name.toUpperCase();
  //   return '$hours:$minutes $timePeriod}';
  // }
}
