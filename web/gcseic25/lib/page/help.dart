import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajuda - Markup Multiplicador'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Como é feito o cálculo do Markup Multiplicador?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                'O Markup Multiplicador é usado para calcular o preço de venda de um produto com base no custo, nas despesas e na margem de lucro desejada.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'Fórmula:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Markup = 100 / [100 - (Despesas Variáveis + Despesas Fixas + Margem de Lucro)]',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'Preço de Venda = Custo × Markup',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 24),
              Text(
                'Exemplo:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Suponha que:\n'
                '- Custo = R\$ 100,00\n'
                '- Despesas Variáveis = 10%\n'
                '- Despesas Fixas = 15%\n'
                '- Margem de Lucro = 25%\n\n'
                'Markup = 100 / [100 - (10 + 15 + 25)] = 100 / 50 = 2,00\n'
                'Preço de Venda = R\$ 100 × 2,00 = R\$ 200,00',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}