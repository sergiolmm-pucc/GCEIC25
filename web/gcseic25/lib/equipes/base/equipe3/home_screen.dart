import 'package:flutter/material.dart';
import 'consulta_screen.dart';
import 'consulta_eletrica_screen.dart';
import 'consulta_hidraulica_screen.dart';  
import 'sobre_screen.dart';
import 'ajuda_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2196F3), Color(0xFFBBDEFB)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 400),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Menu Principal',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800],
                        ),
                      ),
                      SizedBox(height: 30),
                      _buildMenuButton(context, 'Consulta Piscina', Icons.pool, ConsultaScreen()),
                      SizedBox(height: 16),
                      _buildMenuButton(context, 'Consulta Elétrica', Icons.electrical_services, ConsultaEletricaScreen()),  
                      SizedBox(height: 16),
                      _buildMenuButton(context, 'Consulta Hidráulica', Icons.plumbing, ConsultaHidraulicaScreen()),  
                      SizedBox(height: 16),
                      _buildMenuButton(context, 'Sobre', Icons.info_outline, SobreScreen()),
                      SizedBox(height: 16),
                      _buildMenuButton(context, 'Ajuda', Icons.help_outline, AjudaScreen()),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, String label, IconData icon, Widget screen) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue[700],
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        icon: Icon(icon, size: 24, color: Colors.white),
        label: Text(
          label,
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => screen)),
      ),
    );
  }
}
