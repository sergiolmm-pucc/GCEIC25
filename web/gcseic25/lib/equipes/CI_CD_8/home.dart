import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tela Inicial - Grupo CI_CD_8'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Bem-vindo ao projeto!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Aqui o membro 1 pode colocar sua rota
              },
              child: const Text('Módulo do Membro 1'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                // Aqui o membro 2 pode colocar sua rota
              },
              child: const Text('Módulo do Membro 2'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                // Aqui o membro 3 pode colocar sua rota
              },
              child: const Text('Módulo do Membro 3'),
            ),
            // Pode adicionar mais botões conforme precisar
          ],
        ),
      ),
    );
  }
}