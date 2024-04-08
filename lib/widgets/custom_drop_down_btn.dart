import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDDButton extends StatelessWidget {
  const CustomDDButton({
    super.key,
    required this.hintText,
    this.parantValue,
    this.childValue,
    this.onChanged,
    this.items,
  });
  final String hintText;
  final String? parantValue;
  final String? childValue;
  final ValueChanged<String?>? onChanged;
  final List<DropdownMenuItem<String>>? items;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
      ),
      padding: const EdgeInsets.all(10),
      child: DropdownButtonFormField<String>(
        borderRadius: BorderRadius.circular(20),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: InputDecoration.collapsed(
          hintText: hintText,
          hintStyle: GoogleFonts.poppins(),
        ),
        items: items,
        onChanged: onChanged,
      ),
    );
  }
}
