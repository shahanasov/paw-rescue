import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:paw_catcher_admin/core/theme.dart';
import 'package:paw_catcher_admin/presentation/auth/splash_screen.dart';
import 'firebase_options.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme:ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppTheme.softPink)
      ),
      debugShowCheckedModeBanner: false,
      title: 'Paw Rescue',
      home: SplashScreen(),
    );
  }
}