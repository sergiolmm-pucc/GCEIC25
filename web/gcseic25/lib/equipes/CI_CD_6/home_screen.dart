import 'package:flutter/material.dart';
import 'package:gcseic25/equipes/CI_CD_6/help_screen.dart';
import 'package:gcseic25/equipes/CI_CD_6/sobre_screen.dart';
// Importe as outras telas aqui
import 'package:gcseic25/equipes/CI_CD_6/calculos/custo_mensal_screen.dart';
import 'package:gcseic25/equipes/CI_CD_6/calculos/ferias_screen.dart';
import 'package:gcseic25/equipes/CI_CD_6/calculos/recisao_screen.dart';
import 'package:gcseic25/equipes/CI_CD_6/calculos/decimo_terceiro_screen.dart';
import 'package:gcseic25/equipes/CI_CD_6/calculos/esocial_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // HEADER
          Container(
            color: const Color.fromARGB(255, 233, 122, 18),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                const Text(
                  'Calculo ETEC',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => _navigateTo(context, const SobreScreen()),
                  child: const Text(
                    'Sobre',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                TextButton(
                  onPressed: () => _navigateTo(context, const HelpScreen()),
                  child: const Text(
                    'Ajuda',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                // MENU "Cálculos"
                PopupMenuButton<String>(
                  color: Colors.white,
                  onSelected: (value) {
                    switch (value) {
                      case 'custo_mensal':
                        _navigateTo(context, CustoMensalScreen());
                        break;
                      case 'ferias':
                        _navigateTo(context, FeriasScreen());
                        break;
                      case 'recisao':
                        _navigateTo(context, RecisaoScreen());
                        break;
                      case '13':
                        _navigateTo(context, DecimoTerceiroScreen());
                        break;
                      case 'esocial':
                        _navigateTo(context, ESocialScreen());
                        break;
                    }
                  },
                  itemBuilder:
                      (context) => [
                        const PopupMenuItem(
                          value: 'custo_mensal',
                          child: Text('Calcular custo mensal'),
                        ),
                        const PopupMenuItem(
                          value: 'ferias',
                          child: Text('Calcular férias'),
                        ),
                        const PopupMenuItem(
                          value: 'recisao',
                          child: Text('Calcular rescisão'),
                        ),
                        const PopupMenuItem(
                          value: '13',
                          child: Text('Calcular 13º salário'),
                        ),
                        const PopupMenuItem(
                          value: 'esocial',
                          child: Text('Calcular eSocial'),
                        ),
                      ],
                  child: const Text(
                    'Cálculos',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  icon: const Icon(Icons.logout, color: Colors.white),
                  tooltip: 'Voltar',
                  onPressed: () {
                    Navigator.pop(
                      context,
                    ); // ou navegue para login se for o caso
                  },
                ),
              ],
            ),
          ),

          // CORPO PRINCIPAL
          const Expanded(
            child: Center(child: Text('Bem-vindo à tela inicial!')),
          ),
        ],
      ),
    );
  }
}
