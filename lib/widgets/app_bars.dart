import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppBars {
  static PreferredSizeWidget appBar(title, subtitle) {
    return AppBar(
      title: Column(
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
          Text(
            subtitle,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.normal,
              fontSize: 22,
            ),
          ),
        ],
      ),
      centerTitle: true,
    );
  }
}
