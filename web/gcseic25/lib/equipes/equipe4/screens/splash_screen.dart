import 'dart:async';
import 'package:flutter/material.dart';

class SplashScreen4 extends StatefulWidget {
  final Widget nextPage;

  const SplashScreen4({super.key, required this.nextPage});

  @override
  State<SplashScreen4> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen4> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
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
        child: Image.asset('assets/equipe4/logo_equipe_4.png', width: 500, height: 500),
      ),
    );
  }
}  
