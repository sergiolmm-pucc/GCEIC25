import 'package:flutter/material.dart';
import 'package:gcseic25/equipes/equipe4/screens/login.dart';
import 'package:gcseic25/equipes/equipe4/screens/water_volume.dart';
import '../utils/tab_bar.dart';

class HomeScreen4 extends StatelessWidget {
  const HomeScreen4({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Bem-vindo ao app!',
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WaterVolumePage(),
                    ),
                  );
                },
                child: const Text('Cálculo do Volume'),
              ),

              const SizedBox(height: 12), // Espaço entre os botões

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                  );
                },
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
