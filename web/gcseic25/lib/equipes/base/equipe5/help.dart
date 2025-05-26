import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajuda')),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: 350,
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Text(
                  'Como utilizar o aplicativo',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24),

                Text(
                  '• Cálculo de IPI',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Esse botão leva à tela para calcular o Imposto sobre Produtos Industrializados.',
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),

                Text(
                  '• Cálculo de ICMS',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Esse botão leva à tela para calcular o Imposto sobre Circulação de Mercadorias e Serviços.',
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),

                Text(
                  '• Cálculo de ISS',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Esse botão leva à tela para calcular o Imposto Sobre Serviços.',
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),

                Text(
                  '• Cálculo de IRPJ',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Esse botão leva à tela para calcular o Imposto de Renda Pessoa Jurídica.',
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),

                Text(
                  '• Sobre nós',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Esse botão leva a uma tela com informações sobre os desenvolvedores do aplicativo.',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
