import 'package:flutter/material.dart';

class SobreScreen extends StatelessWidget {
  const SobreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Sobre o App',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Text(
            style: const TextStyle(color: Colors.white, fontSize: 16, height: 1.4),
            '''
            
            
Descubra o poder da informação na palma da sua mão!
Com nosso aplicativo, você tem acesso rápido e fácil a ferramentas essenciais do dia a dia:

• Validação de CPF: Consulte se um CPF é válido e está registrado na base de dados.

• Verificação de CNH: Saiba se a Carteira Nacional de Habilitação (CNH) informada é legítima.

• Simulação de Seguro: Calcule em instantes o valor estimado do seguro do seu veículo com base em:

Ano do veículo

Marca e modelo

Idade do motorista

Tempo de habilitação

Nosso app foi criado para ser simples, prático e eficiente. Chega de burocracia: acesse, digite os dados e tenha as respostas que precisa, de forma segura e rápida.


            ''',
          ),
        ),
      ),
    );
  }
}
