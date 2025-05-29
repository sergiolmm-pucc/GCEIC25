import 'package:flutter/material.dart';
import 'dart:async';
import 'login_screen.dart';

class APOSSplashScreen extends StatefulWidget {
  const APOSSplashScreen({Key? key}) : super(key: key);

  @override
  _APOSSplashScreenState createState() => _APOSSplashScreenState();
}

class _APOSSplashScreenState extends State<APOSSplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Configura o AnimationController e Animation para Fade
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    _controller.forward();

    // Timer para trocar a tela após 10 segundos
    Timer(const Duration(seconds: 10), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // Sempre dispõe o controller para liberar recursos
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/APOS/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _animation,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/APOS/logo_white.png', height: 140),
                const SizedBox(height: 24),
                const Text(
                  'Aposentadoria Fácil',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Seu futuro tranquilo começa aqui',
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
                const SizedBox(height: 32),
                const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
