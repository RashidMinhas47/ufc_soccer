import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final urlCtrProvider =
    Provider<TextEditingController>((ref) => TextEditingController());
final locationController =
    Provider<TextEditingController>((ref) => TextEditingController());
final managerController =
    Provider<TextEditingController>((ref) => TextEditingController());
final appAccessCodeCtrl =
    Provider<TextEditingController>((ref) => TextEditingController());

final homePagesControler = ChangeNotifierProvider((ref) => PageController());
final gameTitleCtrPro =
    Provider<TextEditingController>((ref) => TextEditingController());
