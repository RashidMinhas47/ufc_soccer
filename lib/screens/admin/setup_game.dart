import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ufc_soccer/providers/date_time_provider.dart';
import 'package:ufc_soccer/providers/manage_app_provider.dart';
import 'package:ufc_soccer/providers/setup_game_provider.dart';
import 'package:ufc_soccer/providers/text_controllers.dart';
import 'package:ufc_soccer/screens/app_nav_bar.dart';
import 'package:ufc_soccer/screens/profile_screens/edit_profile_screen.dart';
import 'package:ufc_soccer/utils/constants.dart';
import 'package:ufc_soccer/widgets/app_bars.dart';
import 'package:ufc_soccer/widgets/custom_large_btn.dart';
import 'package:ufc_soccer/widgets/custom_switch_btn.dart';
import 'package:ufc_soccer/widgets/date_time_buttons.dart';
import 'package:ufc_soccer/widgets/text_field_with_border.dart';

class GameSetupScreen extends ConsumerWidget {
  const GameSetupScreen({super.key});

  static const String screen = "/GameSetupScreen";

  dateFormator(day, month, year) {
    return '$day/$month/$year';
  }

  timeFormator(time, period) {
    return '$time $period';
  }

  @override
  Widget build(BuildContext context, ref) {
    final setGamePro = ref.watch(setupGameProvider);
    final dateTimePro = ref.watch(dateTimeProvider);
    // final adminPro = ref.watch(adminProvider);
    final appSettingsPro = ref.watch(appSettingsProvider);
    final titlePro = ref.watch(gameTitleCtrPro);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBars.appBar('Game Admin', "Setup Game"),
      body: setGamePro.isLoading
          ? prograssWidget
          : Padding(
              padding: kPadd20,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFeildWithBorder(
                      paddH: 20,
                      controller: titlePro,
                      hintText: 'Enter Title',
                    ),
                    DateTimeButtons(
                      time: dateTimePro.selectedTime?.format(context) ??
                          "Select Time",
                      date: dateTimePro.selectedDate?.formattedDate ??
                          "Select Date",
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: 'Location',
                          hintStyle: GoogleFonts.poppins(),
                        ),
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration.collapsed(
                            hintText: 'Location',
                            hintStyle: GoogleFonts.poppins(),
                          ),
                          items: appSettingsPro.locations.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value, style: GoogleFonts.poppins()),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            appSettingsPro.selectLocation(value);
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: 'Manager',
                          hintStyle: GoogleFonts.poppins(),
                        ),
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration.collapsed(
                            hintText: 'Manager',
                            hintStyle: GoogleFonts.poppins(),
                          ),
                          items: appSettingsPro.managers.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value, style: GoogleFonts.poppins()),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            appSettingsPro.selectManager(value);
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: 'Max Player',
                          hintStyle: GoogleFonts.poppins(),
                        ),
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration.collapsed(
                            hintText: 'Max Player',
                            hintStyle: GoogleFonts.poppins(),
                          ),
                          items: List.generate(99, (index) => index.toString())
                              .map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text("$value players",
                                  style: GoogleFonts.poppins()),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            setGamePro.setMaxPlayers(value!);
                          },
                        ),
                      ),
                    ),
                    SwitchCustomButton(
                      label: 'Remix Voting',
                      value: setGamePro.remixVoting,
                      onChanged: (value) {
                        setGamePro.setVotingCondition(value);
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: 'Enter Remix Time Countdown',
                          hintStyle: GoogleFonts.poppins(),
                        ),
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration.collapsed(
                            hintText: 'Enter Remix Time Countdown',
                            hintStyle: GoogleFonts.poppins(),
                          ),
                          items: List.generate(99, (index) => index.toString())
                              .map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text("$value hours",
                                  style: GoogleFonts.poppins()),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            setGamePro.setTimeCountdown(value);
                          },
                        ),
                      ),
                    ),
                    LargeFlatButton(
                        onPressed: () {
                          setGamePro
                              .setupGame(
                                title: titlePro.text,
                                context,
                                date: dateTimePro.selectedDate?.formattedDate ??
                                    "did'nt selected date",
                                time:
                                    dateTimePro.selectedTime?.format(context) ??
                                        "Select Time",
                                location: appSettingsPro.selectedLocation!,
                                manager: appSettingsPro.selectedManager!,
                                remixVoting: setGamePro.remixVoting,
                                maxPlayers: setGamePro.maxPlayers!,
                                timeCountdown: setGamePro.timeCountdown!,
                              )
                              .whenComplete(() =>
                                  Navigator.pushReplacementNamed(
                                      context, AppNavBar.screen));
                          // setGamePro.setData(
                          //     context: context,
                          //     location: appSettingsPro.selectedLocation,
                          //     manager: appSettingsPro.selectedManager,
                          //     maxPlayers: setGamePro.maxPlayers,
                          //     remixVoting: setGamePro.remixVoting,
                          //     timePeriod: setGamePro.timeCountdown,
                          //     date: dateFormator(
                          //       dateTimePro.selectedDate!.day,
                          //       dateTimePro.selectedDate!.month,
                          //       dateTimePro.selectedDate!.year,
                          //     ),
                          //     // "${}}/${}/${}",
                          //     time: timeFormator(
                          //         dateTimePro.selectedTime!.format(context),
                          //         dateTimePro.selectedTime!.period
                          //             .toString()
                          //             .toUpperCase())
                          //     // "${dateTimePro.selectedTime!.format(context)} ${dateTimePro.selectedTime!.period.toString().toUpperCase()}",
                          //     );
                        },
                        size: const Size(200, 70),
                        fontColor: kPrimaryColor,
                        label: 'Setup Game',
                        backgroundColor: Colors.white.withOpacity(0)),
                  ],
                ),
              ),
            ),
    );
  }
}

// List<int> generateList = List.generate(30, (index) {
  
// });