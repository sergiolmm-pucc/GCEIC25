import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gcseic25/page/login.dart'; // ou onde está seu LoginPage

class MarkupSplashScreen extends StatefulWidget {
  const MarkupSplashScreen({super.key});

  @override
  _MarkupSplashScreenState createState() => _MarkupSplashScreenState();
}

class _MarkupSplashScreenState extends State<MarkupSplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo.shade900,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calculate_outlined, size: 100, color: Colors.white),
            SizedBox(height: 20),
            Text(
              'Calculadora de Markup',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(color: Colors.white),
            SizedBox(height: 20),
            Text(
              'Carregando...',
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
