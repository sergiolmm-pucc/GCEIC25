import 'package:flutter/material.dart';
import 'login_screen.dart';

class MKP1SplashScreen extends StatefulWidget {
  const MKP1SplashScreen({Key? key}) : super(key: key);

  @override
  _MKP1SplashScreenState createState() => _MKP1SplashScreenState();
}

class _MKP1SplashScreenState extends State<MKP1SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 10), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.local_bar, size: 100, color: Colors.white),
            const SizedBox(height: 20),
            const Text(
              'Bar Markup Calculator',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
