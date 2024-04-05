import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ufc_soccer/providers/auth_providers.dart';

class SignUpButton extends StatelessWidget {
  const SignUpButton(
      {super.key,
      required this.provider,
      required this.nameController,
      required this.emailController,
      required this.passwordController,
      required this.size,
      required this.isToogleScreen,
      required this.onPressed});
  final VoidCallback onPressed;

  final SignUpAuthProvider provider;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final Size size;
  final bool isToogleScreen;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
            fixedSize: Size(size.width * 0.9, 20 * 2.7),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            backgroundColor: Color(0xFF12BCE3)),
        child: Text(
          isToogleScreen ? 'Sign Up' : 'Login',
          style: GoogleFonts.inter(
            fontSize: 16 * 1,
            fontWeight: FontWeight.w500,
            height: 1.2125 * 1 / 1,
            color: Color(0xffffffff),
          ),
        ));
  }
}
