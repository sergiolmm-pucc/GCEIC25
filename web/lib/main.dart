import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(SolarApp());
}

class SolarApp extends StatelessWidget {
  const SolarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simulador Solar',
      home: SplashScreen(),
    );
  }
}
