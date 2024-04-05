import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ufc_soccer/providers/game_info_providers.dart';
import 'package:ufc_soccer/providers/manage_app_provider.dart';
import 'package:ufc_soccer/providers/text_controllers.dart';
import 'package:ufc_soccer/screens/profile_screens/edit_profile_screen.dart';
import 'package:ufc_soccer/utils/constants.dart';
import 'package:ufc_soccer/widgets/custom_large_btn.dart';
import 'package:ufc_soccer/widgets/text_field_with_border.dart';

import '../../widgets/app_bars.dart';

final urlControllerProvider =
    Provider<TextEditingController>((ref) => TextEditingController());

class ManageAppSettings extends ConsumerWidget {
  static const String screen = "/UpdateDropDownScreen";

  const ManageAppSettings({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final size = MediaQuery.of(context).size;
    // final locationUrlPro = ref.read(locationCtrProvider);
    // final gameInfoState = ref.read(gameInfoProvider.notifier);
    final appAccessCtr = ref.watch(appAccessCodeCtrl);

    final managerCtr = ref.watch(managerController);

    final locationCtr = ref.watch(locationController);
    final appSettingsPro = ref.watch(appSettingsProvider);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBars.appBar("Game Admin", "Manage App Settings"),
      body: appSettingsPro.isUpdation
          ? prograssWidget
          : Padding(
              padding: kPadd20,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFeildWithBorder(
                              controller: locationCtr,
                              hintText: 'Enter Locations'),
                        ),
                        IconButton(
                            onPressed: () {
                              if (locationCtr.text.isNotEmpty) {
                                appSettingsPro.addLocation(locationCtr.text);
                                locationCtr.clear();
                              }
                            },
                            icon: const Icon(
                              Icons.add,
                              size: 34,
                            ))
                      ],
                    ),
                    Container(
                        height: 166,
                        width: double.maxFinite,
                        child: ListView.builder(
                          itemCount: appSettingsPro.locations.length,
                          itemBuilder: (context, index) =>
                              buildOptionTiles(appSettingsPro.locations[index]),
                        )),
                    Row(
                      children: [
                        Expanded(
                          child: TextFeildWithBorder(
                              controller: managerCtr,
                              hintText: 'Enter Managers'),
                        ),
                        IconButton(
                            onPressed: () {
                              if (managerCtr.text.isNotEmpty) {
                                appSettingsPro.addManager(managerCtr.text);
                                managerCtr.clear();
                              }
                            },
                            icon: const Icon(
                              Icons.add,
                              size: 34,
                            ))
                      ],
                    ),
                    Container(
                        height: 166,
                        width: double.maxFinite,
                        child: ListView.builder(
                          itemCount: appSettingsPro.managers.length,
                          itemBuilder: (context, index) =>
                              buildOptionTiles(appSettingsPro.managers[index]),
                        )),
                    Text(
                      "Update access code required to create an account",
                      style: GoogleFonts.poppins(
                          fontSize: 18, color: kBlackColor.withOpacity(0.5)),
                    ),
                    TextFeildWithBorder(
                      paddH: 40,
                      controller: appAccessCtr,
                      hintText: 'APP Access Code',
                    ),
                    LargeFlatButton(
                      onPressed: () {
                        appSettingsPro
                            .updateAppAccessCode(appAccessCtr.text)
                            .whenComplete(
                                () => appSettingsPro.updateAppSettings());
                        appAccessCtr.clear();
                      },
                      size: size,
                      fontColor: kPrimaryColor,
                      label: 'Update App Settings',
                      backgroundColor: Colors.white.withOpacity(0),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
    );
  }

  Column buildOptionTiles(String label) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: const Icon(
                  Icons.compass_calibration,
                  size: 12,
                ),
              ),
              Text(
                label,
                style: GoogleFonts.poppins(fontSize: 14),
              ),
            ],
          ),
        ),
        Divider(
          height: 0,
          endIndent: 10,
          indent: 10,
          thickness: 1.4,
          color: Colors.grey.withOpacity(0.3),
        ),
      ],
    );
  }
}
