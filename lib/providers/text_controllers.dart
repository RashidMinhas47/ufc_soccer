import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_soccer/providers/manage_app_provider.dart';

final urlCtrProvider =
    Provider<TextEditingController>((ref) => TextEditingController());
final locationController =
    Provider<TextEditingController>((ref) => TextEditingController());
final managerController =
    Provider<TextEditingController>((ref) => TextEditingController());
// final appAccessCodeCtrl = FutureProvider<TextEditingController>((ref) async {
//   String? alreadyCode = await ref.watch(appSettingsProvider).getAppAccessCode();
//   return TextEditingController(text: alreadyCode);
// });
final appAccessCodeCtrl = FutureProvider<TextEditingController>((ref) async {
  String? alreadyCode = await ref.watch(appSettingsProvider).getAppAccessCode();

  // Create a TextEditingController with the retrieved code as its initial text
  TextEditingController controller =
      TextEditingController(text: alreadyCode ?? '');

  return controller;
});

final homePagesControler = ChangeNotifierProvider((ref) => PageController());
final gameTitleCtrPro =
    Provider<TextEditingController>((ref) => TextEditingController());
final currentGameGoalsCtr =
    Provider<TextEditingController>((ref) => TextEditingController());
final redTeamGoalCtr =
    Provider<TextEditingController>((ref) => TextEditingController());
final blueTeamGoalCtr =
    Provider<TextEditingController>((ref) => TextEditingController());
