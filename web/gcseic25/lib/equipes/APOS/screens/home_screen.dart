import 'package:flutter/material.dart';
import 'calculo_screen.dart';
import 'simulacao_screen.dart';
import 'regras_screen.dart';
import 'quando_screen.dart';
import 'historico_screen.dart';
import 'sobre_screen.dart';
import 'ajuda_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final List<HomeOption> options = [
    HomeOption(
      title: 'Calcular aposentadoria',
      icon: Icons.calculate,
      color: Colors.teal.shade700,
      screen: const CalculoScreen(),
    ),
    HomeOption(
      title: 'Simular tempo restante',
      icon: Icons.timeline,
      color: Colors.teal.shade600,
      screen: const SimulacaoScreen(),
    ),
    HomeOption(
      title: 'Ver regras atuais',
      icon: Icons.rule,
      color: Colors.teal.shade500,
      screen: const RegrasScreen(),
    ),
    HomeOption(
      title: 'Quando posso me aposentar?',
      icon: Icons.event_available,
      color: Colors.teal.shade400,
      screen: const QuandoScreen(),
    ),
    HomeOption(
      title: 'Histórico de simulações',
      icon: Icons.history,
      color: Colors.teal.shade300,
      screen: const HistoricoScreen(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 700;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F5),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Topo com logo e ícones
              Row(
                children: [
                  Image.asset('assets/APOS/logo.png', height: 48),
                  const SizedBox(width: 12),
                  Text(
                    'Aposentadoria Fácil',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal.shade800,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(Icons.info_outline, color: Colors.teal.shade700),
                    tooltip: 'Sobre',
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => SobreScreen()));
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.help_outline, color: Colors.teal.shade700),
                    tooltip: 'Ajuda',
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => AjudaScreen()));
                    },
                  ),
                ],
              ),

              const SizedBox(height: 24),

              Text(
                'Olá, usuário!',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey.shade900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Seu futuro tranquilo começa aqui.',
                style: TextStyle(fontSize: 18, color: Colors.grey.shade700),
              ),

              const SizedBox(height: 28),

              // Grid de opções
              Expanded(
                child: GridView.count(
                  crossAxisCount: isWide ? 3 : 1,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 3.5,
                  children:
                      options.map((option) {
                        return Material(
                          color: Colors.white,
                          elevation: 2,
                          borderRadius: BorderRadius.circular(16),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => option.screen,
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: option.color.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.all(12),
                                    child: Icon(
                                      option.icon,
                                      color: option.color,
                                      size: 28,
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: Text(
                                      option.title,
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey.shade900,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: 18,
                                    color: Colors.grey.shade400,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeOption {
  final String title;
  final IconData icon;
  final Color color;
  final Widget screen;

  HomeOption({
    required this.title,
    required this.icon,
    required this.color,
    required this.screen,
  });
}
