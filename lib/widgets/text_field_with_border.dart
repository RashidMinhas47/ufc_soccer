import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextFeildWithBorder extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextStyle textStyle;
  final Color borderColor;
  final double borderRadius;
  final ValueChanged<String>? onChanged;
  final double paddH;

  const TextFeildWithBorder({
    super.key,
    required this.controller,
    required this.hintText,
    this.textStyle = const TextStyle(), // Default to empty TextStyle
    this.borderColor = Colors.grey,
    this.borderRadius = 0.0,
    this.onChanged,
    this.paddH = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: paddH),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.poppins().merge(textStyle),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(
              color: borderColor,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(
              color: borderColor,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(
              color: borderColor,
            ),
          ),
        ),
      ),
    );
  }
}
