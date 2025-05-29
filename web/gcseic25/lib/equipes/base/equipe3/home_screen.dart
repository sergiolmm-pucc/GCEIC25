import 'package:flutter/material.dart';
import 'consulta_screen.dart';
import 'sobre_screen.dart';
import 'ajuda_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Menu Principal')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(child: Text('Consulta Piscina'), onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => ConsultaScreen()));
            }),
            ElevatedButton(child: Text('Sobre'), onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => SobreScreen()));
            }),
            ElevatedButton(child: Text('Ajuda'), onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => AjudaScreen()));
            }),
          ],
        ),
      ),
    );
  }
}
