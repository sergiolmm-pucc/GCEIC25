import 'package:flutter/material.dart';

class HomeScreen4 extends StatelessWidget {
  const HomeScreen4({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tela Principal'),
        backgroundColor: const Color(0xFF1274F1),
      ),
      body: const Center(
        child: Text('Bem-vindo ao app!', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
