import 'package:flutter/material.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajuda')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Ajuda',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                'Este aplicativo tem como objetivo auxiliar empregadores no cálculo dos tributos devidos à empregada doméstica, de forma simples e automatizada.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 24),
              Text(
                'Como usar:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                '1. Informe o salário da empregada doméstica.\n'
                '2. Preencha a quantidade de horas trabalhadas no mês.\n'
                '3. Indique o tempo de serviço (em anos).\n'
                '4. Informe o número de filhos, se houver.\n'
                '5. Escolha o estado civil da empregada.\n'
                '6. O app calculará automaticamente os tributos devidos (INSS, IRRF, FGTS, etc.), bem como abonos ou descontos aplicáveis.',
                style: TextStyle(fontSize: 16),
              ),

              SizedBox(height: 24),
              Text(
                'Importante:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                '- Os cálculos são baseados nas regras vigentes da legislação brasileira.\n'
                '- Sempre confira as informações com seu contador ou diretamente no eSocial.\n'
                '- O aplicativo não substitui orientação profissional, mas é uma ferramenta para facilitar seu dia a dia.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 24),
              Text(
                'Dúvidas ou sugestões?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Entre em contato com nossa equipe em caso de dúvidas ou sugestões.',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
