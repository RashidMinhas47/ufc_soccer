import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ufc_soccer/utils/image_urls.dart';

class AuthTextField extends StatelessWidget {
  AuthTextField({
    super.key,
    required this.hintText,
    this.controller,
    required this.iconPath,
    this.obscureText = false,
    this.suffixIcon,
  });
  final String hintText;
  bool obscureText = false;
  final String iconPath;
  final TextEditingController? controller;
  Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0.0, vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Color(0x19000000)),
        color: Color(0xffffffff),
        borderRadius: BorderRadius.circular(4 * 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            width: 19 * 1,
            height: 15 * 1,
            child: SvgPicture.asset(
              iconPath,
              color: Color.fromARGB(255, 70, 69, 69),
              width: 19 * 1,
              height: 15 * 1,
            ),
          ),
          Expanded(
            child: TextFormField(
              // emailpv8 (211:62)
              style: GoogleFonts.inter(
                fontSize: 14 * 1,
                fontWeight: FontWeight.w400,
                height: 1.2125 * 1 / 1,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
              controller: controller,
              obscureText: obscureText,
              decoration: InputDecoration(
                hintText: hintText,
                border: InputBorder.none,
                hintStyle: GoogleFonts.inter(
                  fontSize: 14 * 1,
                  fontWeight: FontWeight.w400,
                  height: 1.2125 * 1 / 1,
                  color: Color(0xff999999),
                ),
                suffixIcon: suffixIcon,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
