import 'package:flutter/material.dart';

class SobreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sobre a Equipe')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(radius: 60, backgroundImage: AssetImage('assets/foto.png')),
            SizedBox(height: 16),
            Text("Equipe MOB 3", style: TextStyle(fontSize: 18)),
            Text("Aplicativo de Cálculo de Piscinas")
          ],
        ),
      ),
    );
  }
}
