import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gcseic25/equipes/equipe2/screens/mob.dart';
import 'package:gcseic25/equipes/equipe2/screens/water_volume.dart';
import 'package:gcseic25/equipes/equipe2/screens/hydraulic_material.dart';
import 'package:gcseic25/equipes/equipe2/screens/maintenance.dart';
import 'package:gcseic25/equipes/equipe2/screens/water_cost.dart';
import 'package:gcseic25/equipes/equipe2/screens/eletric_material.dart';
import '../utils/tab_bar.dart';

class HomeScreen2 extends StatelessWidget {
  const HomeScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: Theme.of(context).textTheme.apply(
              fontFamily: 'Montserrat',
            ),
      ),
      child: MainLayout(
        isHome: true,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 70),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 240, top: 230),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    style: const TextStyle(
                                      fontSize: 60,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                    children: [
                                      const TextSpan(text: 'Calcule o custo para\n'),
                                      const TextSpan(text: 'construir '),
                                      TextSpan(
                                        text: 'sua piscina',
                                        style: TextStyle(
                                          color: Color(0xFFFB9942),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'Cálculo de volume, material elétrico, hidráulica, custo da água e gasto\n'
                                  'mensal de manutenção.',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Coluna da direita com o container centralizado verticalmente
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 190),
                        child: Align(
                          alignment: Alignment.center,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                width: 500,
                                height: 430,
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.2),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Gasto total',
                                      style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    // 🔹 Duas colunas lado a lado
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        // 🔸 Primeira coluna
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: const [
                                            Text(
                                              'Volume',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              '0 m³',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 22,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            SizedBox(height: 16),
                                            Text(
                                              'Custo hidráulico',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              'R\$ 0',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 22,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            SizedBox(height: 16),
                                            Text(
                                              'Custo de manutenção',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              'R\$ 0',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 22,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),

                                        // 🔸 Segunda coluna
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: const [
                                            Text(
                                              'Custo de material elétrico',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              'R\$ 0',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 22,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            SizedBox(height: 16),
                                            Text(
                                              'Custo d\'água',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              'R\$ 0',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 22,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            SizedBox(height: 16),
                                            Text(
                                              'MOB',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              'R\$ 0',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 22,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 30),

                                    const Text(
                                      'Total',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      'R\$ 0,00',
                                      style: TextStyle(
                                        color: Colors.blueAccent,
                                        fontSize: 26,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      ),
                    ],
                  ),

              ),

              const SizedBox(height: 80),

              // 🔘 Botões centralizados na parte de baixo da tela
              Wrap(
                spacing: 40,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: [
                  buildButtonCard(
                    context: context,
                    title: 'Manutenção',
                    subtitle: 'Calcular o custo da manutenção.',
                    imageUrl: 'assets/equipe2/manutencao.png',
                    page: const MaintenancePage(),
                  ),
                  buildButtonCard(
                    context: context,
                    title: 'Custo d\'água',
                    subtitle: 'Calcular o custo da água.',
                    imageUrl: 'assets/equipe2/custo_agua.png',
                    page: const WaterCostPage(),
                  ),
                  buildButtonCard(
                    context: context,
                    title: 'Hidráulica',
                    subtitle: 'Calcular o custo da parte hidráulica.',
                    imageUrl: 'assets/equipe2/hidraulica.png',
                    page: const HydraulicCostPage(),
                  ),
                  buildButtonCard(
                    context: context,
                    title: 'MOB',
                    subtitle: 'Calcular o custo de mobilização.',
                    imageUrl: 'assets/equipe2/mob.png',
                    page: MOBPage(),
                  ),
                  buildButtonCard(
                    context: context,
                    title: 'Material Elétrico',
                    subtitle: 'Calcular custo elétrico.',
                    imageUrl: 'assets/equipe2/eletrica.png',
                    page: const EletricMaterialPage(),
                  ),
                  buildButtonCard(
                    context: context,
                    title: 'Cálculo do Volume',
                    subtitle: 'Calcular o volume de água.',
                    imageUrl: 'assets/equipe2/volume.png',
                    page: const WaterVolumePage(),
                  ),
                ],
              ),
              const SizedBox(height: 40), 
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildButtonCard({
  required BuildContext context,
  required String title,
  required String subtitle,
  required String imageUrl,
  required Widget page,
}) {
  return InkWell(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => page),
      );
    },
    borderRadius: BorderRadius.circular(16),
    child: Container(
      width: 180,
      height: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // 🖼️ Imagem de fundo
            Positioned.fill(
              child: Image.asset(
                imageUrl,
                fit: BoxFit.cover,
              ),
            ),

            // 🔲 Gradiente no rodapé
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.8),
                      Colors.white.withOpacity(0.4),
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        fontWeight: FontWeight.w600
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ➡️ Ícone de seta no canto inferior direito
            const Positioned(
              bottom: 12,
              right: 12,
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white70,
                size: 18,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

