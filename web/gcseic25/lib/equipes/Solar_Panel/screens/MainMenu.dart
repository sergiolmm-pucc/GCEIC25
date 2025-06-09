import 'package:flutter/material.dart';
import 'CalcularScreen.dart';
import 'ImpactoAmbientalScreen.dart';
import 'OrientacaoScreen.dart';
import 'AboutUsScreen.dart';

class MainMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF7B1FA2), Color(0xFF2196F3)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 40),
                  Text(
                    'Menu Principal',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.5,
                      shadows: [Shadow(blurRadius: 8, color: Colors.black26, offset: Offset(2,2))],
                    ),
                  ),
                  SizedBox(height: 40),
                  _menuButton(context, 'Simulação de Cálculo', CalcularScreen()),
                  SizedBox(height: 24),
                  _menuButton(context, 'Impacto Ambiental', ImpactoAmbientalScreen()),
                  SizedBox(height: 24),
                  _menuButton(context, 'Orientação de Instalação', OrientacaoScreen()),
                  SizedBox(height: 48),
                  _aboutUsButton(context),
                  SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _menuButton(BuildContext context, String label, Widget screen) {
    return SizedBox(
      width: 300,
      height: 60,
      child: ElevatedButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        ),
        child: Text(label, style: TextStyle(fontSize: 20)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF7B1FA2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          elevation: 6,
        ),
      ),
    );
  }

  Widget _aboutUsButton(BuildContext context) {
    return SizedBox(
      width: 220,
      height: 54,
      child: ElevatedButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AboutUsScreen()),
        ),
        child: Text('Sobre nós', style: TextStyle(fontSize: 18)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.yellow[700],
          foregroundColor: Colors.deepPurple[900],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
          elevation: 8,
        ),
      ),
    );
  }
} 