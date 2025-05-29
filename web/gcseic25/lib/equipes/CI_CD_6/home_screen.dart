import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:gcseic25/equipes/CI_CD_6/help_screen.dart';
import 'package:gcseic25/equipes/CI_CD_6/sobre_screen.dart';
import 'package:gcseic25/equipes/CI_CD_6/calculos/custo_mensal_screen.dart';
import 'package:gcseic25/equipes/CI_CD_6/calculos/ferias_screen.dart';
import 'package:gcseic25/equipes/CI_CD_6/calculos/recisao_screen.dart';
import 'package:gcseic25/equipes/CI_CD_6/calculos/decimo_terceiro_screen.dart';
import 'package:gcseic25/equipes/CI_CD_6/calculos/esocial_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _waveController;
  late AnimationController _floatController;
  late AnimationController _pulseController;
  
  late Animation<double> _waveAnimation;
  late Animation<double> _floatAnimation;
  late Animation<double> _pulseAnimation;

  final List<Map<String, dynamic>> calculoOptions = [
    {
      'title': 'Custo Mensal',
      'subtitle': 'Calcule os custos mensais completos',
      'icon': Icons.calculate_outlined,
      'color': const Color(0xFFE97A12),
      'screen': () => CustoMensalScreen(),
    },
    {
      'title': 'Férias',
      'subtitle': 'Calcule o valor das férias',
      'icon': Icons.beach_access_outlined,
      'color': const Color(0xFFFF6B35),
      'screen': () => FeriasScreen(),
    },
    {
      'title': 'Rescisão',
      'subtitle': 'Calcule valores de rescisão',
      'icon': Icons.exit_to_app_outlined,
      'color': const Color(0xFFFF8C42),
      'screen': () => RecisaoScreen(),
    },
    {
      'title': '13º Salário',
      'subtitle': 'Calcule o décimo terceiro',
      'icon': Icons.card_giftcard_outlined,
      'color': const Color(0xFFFFB84D),
      'screen': () => DecimoTerceiroScreen(),
    },
    {
      'title': 'eSocial',
      'subtitle': 'Calcule obrigações do eSocial',
      'icon': Icons.account_balance_outlined,
      'color': const Color(0xFFFF9500),
      'screen': () => ESocialScreen(),
    },
  ];

  @override
  void initState() {
    super.initState();
    
    _waveController = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    );
    _waveAnimation = Tween<double>(begin: 0, end: 2 * math.pi)
        .animate(_waveController);
    
    _floatController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );
    _floatAnimation = Tween<double>(begin: -12, end: 12)
        .animate(CurvedAnimation(parent: _floatController, curve: Curves.easeInOut));
    
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2)
        .animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));
    
    _waveController.repeat();
    _floatController.repeat(reverse: true);
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _waveController.dispose();
    _floatController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: AnimatedBuilder(
        animation: Listenable.merge([_waveAnimation, _floatAnimation, _pulseAnimation]),
        builder: (context, child) {
          return Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.topCenter,
                radius: 2.0,
                colors: [
                  Color(0xFF1A1A1A),
                  Color(0xFF0F0F0F),
                  Color(0xFF000000),
                ],
              ),
            ),
            child: Stack(
              children: [
                // Background animated elements
                ...List.generate(4, (index) {
                  return Positioned(
                    top: 50 + (index * 150) + math.sin(_waveAnimation.value + index) * 30,
                    left: 30 + (index * 90) + math.cos(_waveAnimation.value + index) * 25,
                    child: Container(
                      width: 80 + (index * 15),
                      height: 80 + (index * 15),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            calculoOptions[index % calculoOptions.length]['color']
                                .withOpacity(0.08),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  );
                }),
                
                Column(
                  children: [
                    // MODERN HEADER
                    Container(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top + 10,
                        left: 20,
                        right: 20,
                        bottom: 20,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            const Color(0xFFE97A12),
                            const Color(0xFFFF8C42),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFE97A12).withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Transform.scale(
                            scale: _pulseAnimation.value * 0.8 + 0.2,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.calculate,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Calculo ETEC',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Cálculos trabalhistas simplificados',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          // Modern menu buttons
                          _buildModernButton(
                            icon: Icons.info_outline,
                            onTap: () => _navigateTo(context, const SobreScreen()),
                          ),
                          const SizedBox(width: 8),
                          _buildModernButton(
                            icon: Icons.help_outline,
                            onTap: () => _navigateTo(context, const HelpScreen()),
                          ),
                          const SizedBox(width: 8),
                          _buildModernButton(
                            icon: Icons.logout,
                            onTap: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ),

                    // MAIN CONTENT
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Welcome section
                            Transform.translate(
                              offset: Offset(0, _floatAnimation.value * 0.3),
                              child: Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  color: Colors.white.withOpacity(0.05),
                                  border: Border.all(
                                    color: const Color(0xFFE97A12).withOpacity(0.2),
                                    width: 1,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFE97A12).withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(16),
                                          ),
                                          child: const Icon(
                                            Icons.waving_hand,
                                            color: Color(0xFFE97A12),
                                            size: 28,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        const Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Bem-vindo!',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                'Escolha um cálculo para começar',
                                                style: TextStyle(
                                                  color: Colors.white60,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            
                            const SizedBox(height: 32),
                            
                            // Calculations grid
                            const Text(
                              'Cálculos Disponíveis',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 16),
                            
                            ...calculoOptions.asMap().entries.map((entry) {
                              int index = entry.key;
                              Map<String, dynamic> option = entry.value;
                              
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: Transform.translate(
                                  offset: Offset(
                                    math.sin(_waveAnimation.value + index * 0.3) * 4,
                                    _floatAnimation.value * (0.2 + index * 0.05),
                                  ),
                                  child: GestureDetector(
                                    onTap: () => _navigateTo(context, option['screen']()),
                                    child: Container(
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.white.withOpacity(0.03),
                                        border: Border.all(
                                          color: option['color'].withOpacity(0.3),
                                          width: 1,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: option['color'].withOpacity(0.1),
                                            blurRadius: 20,
                                            offset: const Offset(0, 5),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(16),
                                            decoration: BoxDecoration(
                                              color: option['color'].withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(16),
                                              border: Border.all(
                                                color: option['color'].withOpacity(0.3),
                                                width: 1,
                                              ),
                                            ),
                                            child: Icon(
                                              option['icon'],
                                              color: option['color'],
                                              size: 28,
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  option['title'],
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  option['subtitle'],
                                                  style: TextStyle(
                                                    color: Colors.white.withOpacity(0.6),
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: option['color'].withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Icon(
                                              Icons.arrow_forward_ios,
                                              color: option['color'],
                                              size: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                            
                            const SizedBox(height: 32),
                            
                            // Info footer
                            Transform.translate(
                              offset: Offset(0, _floatAnimation.value * 0.2),
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: Colors.white.withOpacity(0.02),
                                  border: Border.all(
                                    color: const Color(0xFFE97A12).withOpacity(0.1),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.info_outline,
                                      color: const Color(0xFFE97A12).withOpacity(0.7),
                                      size: 20,
                                    ),
                                    const SizedBox(width: 12),
                                    const Expanded(
                                      child: Text(
                                        'Cálculos baseados na legislação brasileira vigente',
                                        style: TextStyle(
                                          color: Colors.white54,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildModernButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }
}