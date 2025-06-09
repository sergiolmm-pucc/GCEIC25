import 'package:flutter/material.dart';

class AjudaScreen extends StatelessWidget {
  const AjudaScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajuda')),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Semantics(
            label: 'Conteúdo Ajuda',
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Como funciona a aplicação?',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'O aplicativo MKP1 foi criado para facilitar o cálculo de markup e precificação de produtos para bares. Ele permite que você insira os custos, despesas, impostos e o lucro desejado, e retorna o preço de venda ideal. Também é possível obter sugestões de preço com base em concorrentes.',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Como utilizar:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    '1. Faça login usando o usuário e senha: admin/admin.\n\n2. Escolha o tipo de cálculo desejado (simples, detalhado ou sugestão de preço).\n\n3. Preencha os campos obrigatórios:\n   - Custo do produto\n   - Lucro desejado (%)\n   - Despesas (%) e Impostos (%) (para cálculo detalhado)\n   - Preços dos concorrentes (para sugestão de preço)\n\n4. Clique em "Calcular" para ver o resultado.\n\n5. O resultado será exibido na tela, mostrando o preço de venda sugerido e o lucro.',
                    style: TextStyle(fontSize: 17),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Dúvidas ou problemas?\nEntre em contato com o suporte da equipe MKP1.',
                    style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
