import 'package:flutter/material.dart';
import 'package:ufc_soccer/utils/constants.dart';

class ButtonStyles {
  static ButtonStyle smallOutlineStyle() {
    return OutlinedButton.styleFrom(
      fixedSize: const Size(140, 30),
      shape: RoundedRectangleBorder(
          side: const BorderSide(color: kPrimaryColor, width: 1),
          borderRadius: BorderRadius.circular(0)),
    );
  }
}
