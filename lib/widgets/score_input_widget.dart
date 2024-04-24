import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ufc_soccer/providers/game_info_providers.dart';
import 'package:ufc_soccer/screens/admin/update_player_stats.dart';

class ScoreInputWidget extends StatelessWidget {
  final String label;
  final VoidCallback incrementTap;
  final VoidCallback decrementTap;
  final TextEditingController goalsCtr;

  const ScoreInputWidget(
      {super.key,
      required this.label,
      required this.goalsCtr,
      required this.incrementTap,
      required this.decrementTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(fontSize: 18),
          ),
          const SizedBox(width: 20),
          Container(
            height: 49 + 11,
            width: 100,
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: TextField(
                    controller: goalsCtr,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                    ),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: incrementTap,
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        child: const Icon(
                          Icons.arrow_drop_up,
                          size: 20,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: decrementTap,
                      child: Container(
                        alignment: Alignment.topCenter,
                        child: const Icon(
                          Icons.arrow_drop_down,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
