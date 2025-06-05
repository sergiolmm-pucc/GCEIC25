import 'package:flutter/material.dart';

class SobrePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sobre o App'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'Este aplicativo calcula o markup multiplicador com base nos custos e margens inseridos.\n\nDesenvolvido com Flutter.',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
