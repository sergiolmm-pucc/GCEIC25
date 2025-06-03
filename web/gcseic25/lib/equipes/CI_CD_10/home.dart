import 'package:flutter/material.dart';
import 'package:gcseic25/equipes/CI_CD_10/calcular.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Grupo CI/CD 10'), centerTitle: true),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Cálculo de Encargos trabalhistas de Empregada doméstica',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CalcularPage()),
                  );
                },
                child: const Text('Ir para cálculo'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
