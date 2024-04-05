import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ufc_soccer/utils/constants.dart';

class LargeFlatButton extends StatelessWidget {
  const LargeFlatButton(
      {super.key,
      required this.onPressed,
      required this.size,
      required this.fontColor,
      required this.label,
      this.paddH = 0,
      this.paddV = 10,
      required this.backgroundColor});

  final Size size;
  final Color fontColor;
  final VoidCallback onPressed;
  final String label;
  final Color backgroundColor;
  final double paddH;
  final double paddV;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: paddH, vertical: paddV),
      child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            fixedSize: Size(size.width * 0.9, 20 * 2.7),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
                side: const BorderSide(color: kPrimaryColor)),
            backgroundColor: const Color(0xFF12BCE3).withOpacity(0),
          ),
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 16 * 1,
              fontWeight: FontWeight.w700,
              height: 1.2125 * 1 / 1,
              color: kPrimaryColor,
            ),
          )),
    );
  }
}
