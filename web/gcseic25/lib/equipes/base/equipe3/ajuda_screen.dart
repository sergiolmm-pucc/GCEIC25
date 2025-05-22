import 'package:flutter/material.dart';

class AjudaScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ajuda')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'Preencha os dados da piscina e toque em "Calcular" para ver o custo estimado.\n\n'
          'Caso tenha dúvidas, entre em contato com a equipe MOB3.',
          style: TextStyle(fontSize: 16),
        ),
      ),
    ) ;
  }
}
