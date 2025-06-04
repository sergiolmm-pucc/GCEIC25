import 'package:flutter/material.dart';

class SobreScreen extends StatelessWidget {
  const SobreScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sobre')),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Semantics(
            label: 'Conteúdo Sobre',
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Sobre o Projeto',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Este aplicativo foi desenvolvido como parte do projeto da disciplina de GERÊNCIA DE CONFIGURAÇÃO, ENTREGA E INTEGRAÇÃO CONTÍNUA do curso de Engenharia de Software da PUC-Campinas. O objetivo é auxiliar empreendedores e gestores de bares na região de Campinas a calcular o markup ideal para seus produtos, facilitando a precificação e o controle de lucros.',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Funcionalidades:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    '- Cálculo de markup simples e detalhado\n- Sugestão de preço baseada em concorrentes\n- Interface intuitiva e responsiva',
                    style: TextStyle(fontSize: 17),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Desenvolvedores:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'João Pedro Giaretta\n Filipe Mota\n Caio Gandara\n Thiago Fossa\n Mel Seleghin',
                    style: TextStyle(fontSize: 17),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24),
                  Text(
                    'PUC-Campinas - 2025',
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
