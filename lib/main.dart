import 'package:flutter/material.dart';
import 'constants/app_strings.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/location/location_screen.dart';
import 'features/alarm/alarm_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const OnboardingScreen(),
        '/location': (context) => const LocationScreen(),
      },
    );
  }
}