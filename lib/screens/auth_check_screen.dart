import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_soccer/providers/user_data.dart';
import 'package:ufc_soccer/screens/app_nav_bar.dart';
import 'package:ufc_soccer/screens/authentication_screen.dart';
import 'package:ufc_soccer/screens/home/home_screen.dart';
import 'package:ufc_soccer/screens/profile_screens/edit_profile_screen.dart';

class AuthCheckScreen extends ConsumerStatefulWidget {
  static const String screen = '/AuthCheckScreen';
  const AuthCheckScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AuthCheckScreenState createState() => _AuthCheckScreenState();
}

class _AuthCheckScreenState extends ConsumerState<AuthCheckScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(userDataProvider).checkAuthenticationStatus(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: ref.watch(userDataProvider).checkAuthenticationStatus(context),
        builder: (context, snapshot) => FutureBuilder(
          future: ref.watch(userDataProvider).fetchUserData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              ref.watch(userDataProvider);
              return const AppNavBar();
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else {
              return const AuthScreen();
            }
          },
        ),
      ),
    );
  }
}
