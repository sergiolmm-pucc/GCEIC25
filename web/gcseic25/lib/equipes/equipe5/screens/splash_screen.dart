import 'package:flutter/material.dart';
import 'calculo_ipi.dart';
import 'calculo_icms.dart';
import 'calculo_iss.dart';
import 'calculo_irpj.dart';
import 'sobre.dart';
import 'help.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0D47A1), // Azul escuro
              Colors.white,
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Calculadora de impostos',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Contraste com o fundo azul
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CalculoIpiPage(),
                        ),
                      );
                    },
                    child: const Text('Cálculo de IPI'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CalculoIcmsPage(),
                        ),
                      );
                    },
                    child: const Text('Cálculo de ICMS'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CalculoIrpjPage(),
                        ),
                      );
                    },
                    child: const Text('Cálculo de IRPJ'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CalculoIssPage(),
                        ),
                      );
                    },
                    child: const Text('Cálculo de ISS'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SobrePage(),
                        ),
                      );
                    },
                    child: const Text('Sobre nós'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HelpPage(),
                        ),
                      );
                    },
                    child: const Text('Help'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
