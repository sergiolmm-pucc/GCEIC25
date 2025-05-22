import 'package:flutter/material.dart';

class QuandoScreen extends StatelessWidget {
  const QuandoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quando posso me aposentar?')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bem-vindo!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text('Este é o conteúdo da sua tela.'),
          ],
        ),
      ),
    );
  }
}
