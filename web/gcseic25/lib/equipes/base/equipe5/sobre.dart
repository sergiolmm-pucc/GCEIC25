import 'package:flutter/material.dart';

class SobrePage extends StatelessWidget {
  const SobrePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sobre')),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: 350,
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const SizedBox(height: 32),

                // Image placeholder centralizado
                Image.asset(
                  'assets/equipe5/sobre.jpeg',
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),

                const SizedBox(height: 24),

                const Text(
                  'Somos 3 estudantes de Engenharia de Software:\nEnzo, Guilherme e Rafael',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
