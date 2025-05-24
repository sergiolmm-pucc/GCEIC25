import 'package:flutter/material.dart';
import 'calculo_ipi.dart';
import 'calculo_icms.dart';
import 'calculo_iss.dart';
import 'calculo_pis.dart';
import 'sobre.dart';
import 'help.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Bem-vindo!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CalculoIpiPage()),
                    );
                  },
                  child: const Text('Cálculo de IPI'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CalculoIcmsPage()),
                    );
                  },
                  child: const Text('Cálculo de ICMS'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Assumindo que você também tem calculo_pis.dart
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CalculoPisPage()),
                    );
                  },
                  child: const Text('Cálculo de PIS/CONFINS'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CalculoIssPage()),
                    );
                  },
                  child: const Text('Cálculo de ISS'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SobrePage()),
                    );
                  },
                  child: const Text('Sobre nós'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const HelpPage()),
                    );
                  },
                  child: const Text('Help'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
