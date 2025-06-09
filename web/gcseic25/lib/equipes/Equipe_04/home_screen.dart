import 'package:flutter/material.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Segura Auto',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Escolha uma opção:',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            _buildMenuButton(context, 'Validar CPF', Icons.assignment_ind, '/cpf'),
            const SizedBox(height: 20),
            _buildMenuButton(context, 'Validar CNH', Icons.credit_card, '/cnh'),
            const SizedBox(height: 20),
            _buildMenuButton(context, 'Calcular Seguro', Icons.shield, '/calculate-premium'),
            const SizedBox(height: 20), // espaço antes do botão Sobre
            _buildMenuButton(context, 'Sobre', Icons.info_outline, '/sobre_screen'),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, String label, IconData icon, String route) {
    return ElevatedButton.icon(
      onPressed: () => Navigator.pushNamed(context, route),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 4,
      ),
      icon: Icon(icon),
      label: Text(
        label,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }
}
