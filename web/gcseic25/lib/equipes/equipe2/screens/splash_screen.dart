import 'dart:async';
import 'package:flutter/material.dart';

class SplashScreen2 extends StatefulWidget {
  final Widget nextPage;

  const SplashScreen2({super.key, required this.nextPage});

  @override
  State<SplashScreen2> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen2> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 6), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => widget.nextPage),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1274F1),
      body: Center(
        child: Image.asset('assets/equipe2/logo_equipe_2.png', width: 500, height: 500),
      ),
    );
  }
}  
