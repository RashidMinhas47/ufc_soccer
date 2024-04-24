import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_soccer/models/auth_model.dart';
import 'package:ufc_soccer/providers/user_data.dart';
import 'package:ufc_soccer/screens/app_nav_bar.dart';
import 'package:ufc_soccer/screens/authentication_screen.dart';
import 'package:ufc_soccer/screens/home/home_screen.dart';
import 'package:ufc_soccer/screens/home/pages/join_&_leave_game.dart';
import 'package:ufc_soccer/screens/profile_screens/edit_profile_screen.dart';
import 'package:ufc_soccer/utils/image_urls.dart';

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

    // ref.read(userDataProvider).checkAuthenticationStatus(context);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(builder: (context, ref, child) {
        final authUser = ref.watch(currentUserProvider);
        return authUser.maybeWhen(
          orElse: () {
            return AuthScreen();
          },
          data: (user) {
            return FutureBuilder(
              future: Future.delayed(const Duration(seconds: 1)),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Scaffold(
                      body: Center(
                          child: Image.asset(
                    AppImages.appIcon,
                    height: 200,
                  )));
                } else {
                  // After 3 seconds, show the progress indicator
                  return user != null ? AppNavBar() : AuthScreen();
                }
              },
            );
            // return user != null ? AppNavBar() : AuthScreen();
          },
          loading: () {
            // Delay showing the progress indicator for 3 seconds
            return FutureBuilder(
              future: Future.delayed(Duration(seconds: 1)),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Scaffold(body: progressWidget);
                } else {
                  // After 3 seconds, show the progress indicator
                  return Scaffold(body: prograssWidget);
                }
              },
            );
          },
          error: (error, stackTrace) {
            print('Error: $error');
            return AuthScreen();
          },
        );
      }),
      //  FutureBuilder(
      //   future: ref.watch(userDataProvider).checkAuthenticationStatus(context),
      //   builder: (context, snapshot) => FutureBuilder(
      //     future: ref.watch(userDataProvider).fetchUserData(),
      //     builder: (context, snapshot) {
      //       if (snapshot.hasData) {
      //         ref.watch(userDataProvider);
      //         return const AppNavBar();
      //       } else if (snapshot.connectionState == ConnectionState.waiting) {
      //         return const CircularProgressIndicator();
      //       } else {
      //         return const AuthScreen();
      //       }
      //     },
      //   ),
      // ),
    );
  }
}
