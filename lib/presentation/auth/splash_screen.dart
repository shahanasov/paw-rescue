import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:paw_catcher_admin/core/theme.dart';
import 'package:paw_catcher_admin/presentation/auth/sign_in.dart';
import 'package:paw_catcher_admin/presentation/pages/home/home.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.softPink,
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return HomePage();
            } else {
              return SignInScreen();
            }
          }),
    );
  }
}