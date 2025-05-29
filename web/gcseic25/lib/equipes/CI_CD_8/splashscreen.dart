import 'dart:async';
import 'package:flutter/material.dart';

/// Splash genérica: mostra o layout customizado por 10 s e
/// depois faz pushReplacement para [nextPage].
class SplashScreen extends StatefulWidget {
  final Widget nextPage;
  const SplashScreen({required this.nextPage, super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 10), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => widget.nextPage),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F6FC),
      body: Stack(
        children: [
          /* ---------- Cabeçalho azul curvo ---------- */
          ClipPath(
            clipper: _CurvedHeaderClipper(),
            child: Container(
              height: 300,
              color: const Color(0xFF007BFF),
              alignment: Alignment.center,
              padding: const EdgeInsets.only(top: 80),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    'CI DC · Grupo 8',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Carregando...',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),

          /* ---------- Card central opcional ---------- */
          Align(
            alignment: const Alignment(0, -0.1),
            child: Container(
              width: 260,
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(height: 24),
                  Text(
                    'Iniciando o aplicativo…',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/* ---------- Clipper reaproveitado ---------- */
class _CurvedHeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..lineTo(0, size.height - 80)
      ..quadraticBezierTo(
          size.width / 2, size.height, size.width, size.height - 80)
      ..lineTo(size.width, 0)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}