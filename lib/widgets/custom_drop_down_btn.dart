import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDDButton extends StatelessWidget {
  const CustomDDButton({
    super.key,
    required this.hintText,
  });
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
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
        items: ['Option 1', 'Option 2', 'Option 3'].map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value, style: GoogleFonts.poppins()),
          );
        }).toList(),
        onChanged: (String? value) {},
      ),
    );
  }
}
