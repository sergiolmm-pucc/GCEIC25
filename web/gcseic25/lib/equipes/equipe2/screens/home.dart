import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:gcseic25/equipes/equipe2/screens/mob.dart';
import 'package:gcseic25/equipes/equipe2/screens/water_volume.dart';
import 'package:gcseic25/equipes/equipe2/screens/hydraulic_material.dart';
import 'package:gcseic25/equipes/equipe2/screens/maintenance.dart';
import 'package:gcseic25/equipes/equipe2/screens/water_cost.dart';
import 'package:gcseic25/equipes/equipe2/screens/eletric_material.dart';
import '../utils/tab_bar.dart';

class HomeScreen2 extends StatefulWidget {
  const HomeScreen2({super.key});

  @override
  State<HomeScreen2> createState() => _HomeScreen2State();
}

class _HomeScreen2State extends State<HomeScreen2> {
  double volume = 0;
  double custoHidraulico = 0;
  double custoManutencao = 0;
  double custoEletrico = 0;
  double custoAgua = 0;
  double custoMob = 0;
  double custoTotal = 0;

  // Método para buscar dados reais da API
  Future<void> buscarDadosDaApi() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/CCP/calcularTotal'),
      );
      print(response.body);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          volume = (data['valorVolume'] ?? 0).toDouble();
          custoEletrico = (data['valorMaterialEletrico'] ?? 0).toDouble();
          custoHidraulico = (data['valorMaterialHidraulico'] ?? 0).toDouble();
          custoAgua = (data['valorCustoAgua'] ?? 0).toDouble();
          custoManutencao = (data['valorManutencaoMensal'] ?? 0).toDouble();
          custoMob = (data['valorMob'] ?? 0).toDouble();
          custoTotal = (data['somaTotal'] ?? 0).toDouble();
        });
      } else {
        print('Erro ao carregar dados da API: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro na conexão com a API: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    buscarDadosDaApi();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: Theme.of(context).textTheme.apply(fontFamily: 'Montserrat'),
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
                                    const TextSpan(
                                      text: 'Calcule o custo para\n',
                                    ),
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
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            const Text(
                                              'Volume',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              '${volume.toStringAsFixed(2)} m³',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 22,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            const SizedBox(height: 16),
                                            const Text(
                                              'Custo hidráulico',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'R\$ ${custoHidraulico.toStringAsFixed(2)}',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 22,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            const SizedBox(height: 16),
                                            const Text(
                                              'Custo de manutenção',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'R\$ ${custoManutencao.toStringAsFixed(2)}',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 22,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            const Text(
                                              'Custo de material elétrico',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'R\$ ${custoEletrico.toStringAsFixed(2)}',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 22,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            const SizedBox(height: 16),
                                            const Text(
                                              'Custo d\'água',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'R\$ ${custoAgua.toStringAsFixed(2)}',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 22,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            const SizedBox(height: 16),
                                            const Text(
                                              'MOB',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'R\$ ${custoMob.toStringAsFixed(2)}',
                                              style: const TextStyle(
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
                                    Text(
                                      'R\$ ${custoTotal.toStringAsFixed(2)}',
                                      style: const TextStyle(
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
                    onReturn: buscarDadosDaApi,
                  ),
                  buildButtonCard(
                    context: context,
                    title: 'Custo de água',
                    subtitle: 'Calcular o custo da água.',
                    imageUrl: 'assets/equipe2/custo_agua.png',
                    page: const WaterCostPage(),
                    onReturn: buscarDadosDaApi,
                  ),
                  buildButtonCard(
                    context: context,
                    title: 'Hidráulica',
                    subtitle: 'Calcular o custo da parte hidráulica.',
                    imageUrl: 'assets/equipe2/hidraulica.png',
                    page: const HydraulicCostPage(),
                    onReturn: buscarDadosDaApi,
                  ),
                  buildButtonCard(
                    context: context,
                    title: 'MOB',
                    subtitle: 'Calcular o custo de mobilização.',
                    imageUrl: 'assets/equipe2/mob.png',
                    page: MOBPage(),
                    onReturn: buscarDadosDaApi,
                  ),
                  buildButtonCard(
                    context: context,
                    title: 'Material Elétrico',
                    subtitle: 'Calcular custo elétrico.',
                    imageUrl: 'assets/equipe2/eletrica.png',
                    page: const EletricMaterialPage(),
                    onReturn: buscarDadosDaApi,
                  ),
                  buildButtonCard(
                    context: context,
                    title: 'Cálculo do Volume',
                    subtitle: 'Calcular o volume de água.',
                    imageUrl: 'assets/equipe2/volume.png',
                    page: const WaterVolumePage(),
                    onReturn: buscarDadosDaApi,
                  ),
                ],
              ),
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
  required VoidCallback onReturn,
}) {
  return Semantics(
    label: 'card_$title'.toLowerCase().replaceAll(' ', '_'),
    hint: 'Abrir página de $title para $subtitle',
    button: true,
    child: InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => page))
            .then((_) {
          onReturn();
        });
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
              Positioned.fill(
                child: Image.asset(imageUrl, fit: BoxFit.cover),
              ),
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
                        Colors.white.withOpacity(0.6),
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
                          color: Colors.grey,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
    ),
  );
}
