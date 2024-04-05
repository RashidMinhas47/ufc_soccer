import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SwitchCustomButton extends StatelessWidget {
  const SwitchCustomButton(
      {super.key,
      required this.label,
      required this.onChanged,
      required this.value});
  final String label;
  final ValueChanged<bool> onChanged;
  final bool value;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(label, style: GoogleFonts.poppins()),
      value: value,
      onChanged: onChanged,
    );
  }
}
