import 'package:flutter/material.dart';
import 'splash_screen.dart';
import 'login_screen.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SplashScreen3(nextPage: LoginScreen()),
  ));
}
