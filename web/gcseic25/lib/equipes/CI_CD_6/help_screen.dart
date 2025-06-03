import 'dart:math' as math;
import 'package:flutter/material.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> with TickerProviderStateMixin {
  late AnimationController _waveController;
  late AnimationController _fadeController;
  late Animation<double> _waveAnimation;
  late Animation<double> _fadeAnimation;

  final List<HelpItem> helpItems = [
    HelpItem(
      icon: Icons.info_outline,
      title: 'Sobre o App',
      description: 'Este aplicativo tem como objetivo auxiliar empregadores no cálculo dos tributos devidos à empregada doméstica, de forma simples e automatizada.',
    ),
    HelpItem(
      icon: Icons.calculate_outlined,
      title: 'Como Calcular',
      description: '1. Informe o salário da empregada doméstica\n2. Preencha a quantidade de horas trabalhadas no mês\n3. Indique o tempo de serviço (em anos)\n4. Informe o número de filhos, se houver\n5. Escolha o estado civil da empregada\n6. O app calculará automaticamente os tributos',
    ),
    HelpItem(
      icon: Icons.warning_amber_outlined,
      title: 'Importante',
      description: '• Os cálculos são baseados nas regras vigentes da legislação brasileira\n• Sempre confira as informações com seu contador ou diretamente no eSocial\n• O aplicativo não substitui orientação profissional',
    ),
    HelpItem(
      icon: Icons.help_outline,
      title: 'Dúvidas ou Sugestões',
      description: 'Entre em contato com nossa equipe em caso de dúvidas ou sugestões. Estamos sempre prontos para ajudar!',
    ),
  ];

  @override
  void initState() {
    super.initState();
    
    _waveController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    );
    _waveAnimation = Tween<double>(begin: 0, end: 2 * math.pi)
        .animate(_waveController);
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(
          parent: _fadeController,
          curve: Curves.easeOutCubic,
        ));
    
    _waveController.repeat();
    _fadeController.forward();
  }

  @override
  void dispose() {
    _waveController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: AnimatedBuilder(
        animation: Listenable.merge([_waveAnimation, _fadeAnimation]),
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
                    top: 100 + (index * 200) + math.sin(_waveAnimation.value + index) * 40,
                    right: 30 + (index * 80) + math.cos(_waveAnimation.value + index) * 30,
                    child: Container(
                      width: 60 + (index * 15),
                      height: 60 + (index * 15),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            const Color(0xFFE97A12).withOpacity(0.04 + index * 0.01),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  );
                }),
                
                SafeArea(
                  child: Column(
                    children: [
                      // Custom App Bar
                      Transform.translate(
                        offset: Offset(0, (1 - _fadeAnimation.value) * -50),
                        child: Opacity(
                          opacity: _fadeAnimation.value,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () => Navigator.pop(context),
                                  child: Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.white.withOpacity(0.05),
                                      border: Border.all(
                                        color: const Color(0xFFE97A12).withOpacity(0.2),
                                        width: 1,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.arrow_back_ios_new,
                                      color: Color(0xFFE97A12),
                                      size: 20,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Central de Ajuda',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'Tire suas dúvidas',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.6),
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFFE97A12), Color(0xFFFF8C42)],
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.help_outline,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      
                      // Content
                      Expanded(
                        child: Transform.translate(
                          offset: Offset(0, (1 - _fadeAnimation.value) * 30),
                          child: Opacity(
                            opacity: _fadeAnimation.value,
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                children: [
                                  const SizedBox(height: 20),
                                  
                                  // Help Cards
                                  ...helpItems.asMap().entries.map((entry) {
                                    final index = entry.key;
                                    final item = entry.value;
                                    
                                    return Transform.translate(
                                      offset: Offset(0, (1 - _fadeAnimation.value) * (20 + index * 10)),
                                      child: Opacity(
                                        opacity: _fadeAnimation.value,
                                        child: Container(
                                          margin: const EdgeInsets.only(bottom: 20),
                                          padding: const EdgeInsets.all(24),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                            color: Colors.white.withOpacity(0.05),
                                            border: Border.all(
                                              color: const Color(0xFFE97A12).withOpacity(0.15),
                                              width: 1,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.2),
                                                blurRadius: 15,
                                                offset: const Offset(0, 5),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    width: 48,
                                                    height: 48,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(14),
                                                      gradient: LinearGradient(
                                                        colors: [
                                                          const Color(0xFFE97A12).withOpacity(0.2),
                                                          const Color(0xFFFF8C42).withOpacity(0.1),
                                                        ],
                                                      ),
                                                    ),
                                                    child: Icon(
                                                      item.icon,
                                                      color: const Color(0xFFE97A12),
                                                      size: 24,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 16),
                                                  Expanded(
                                                    child: Text(
                                                      item.title,
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 16),
                                              Text(
                                                item.description,
                                                style: TextStyle(
                                                  color: Colors.white.withOpacity(0.8),
                                                  fontSize: 15,
                                                  height: 1.5,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  
                                  // Contact Section
                                  Transform.translate(
                                    offset: Offset(0, (1 - _fadeAnimation.value) * 40),
                                    child: Opacity(
                                      opacity: _fadeAnimation.value,
                                      child: Container(
                                        margin: const EdgeInsets.only(bottom: 30),
                                        padding: const EdgeInsets.all(24),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          gradient: LinearGradient(
                                            colors: [
                                              const Color(0xFFE97A12).withOpacity(0.1),
                                              const Color(0xFFFF8C42).withOpacity(0.05),
                                            ],
                                          ),
                                          border: Border.all(
                                            color: const Color(0xFFE97A12).withOpacity(0.3),
                                            width: 1,
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            const Icon(
                                              Icons.support_agent,
                                              color: Color(0xFFE97A12),
                                              size: 48,
                                            ),
                                            const SizedBox(height: 16),
                                            const Text(
                                              'Precisa de mais ajuda?',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              'Nossa equipe está sempre pronta para ajudar você!',
                                              style: TextStyle(
                                                color: Colors.white.withOpacity(0.7),
                                                fontSize: 14,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            const SizedBox(height: 20),
                                            SizedBox(
                                              width: double.infinity,
                                              height: 48,
                                              child: Material(
                                                color: Colors.transparent,
                                                child: InkWell(
                                                  onTap: () {
                                                    // Implementar ação de contato
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(
                                                        content: const Text('Funcionalidade em desenvolvimento'),
                                                        backgroundColor: const Color(0xFFE97A12),
                                                        behavior: SnackBarBehavior.floating,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(12),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  borderRadius: BorderRadius.circular(12),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(12),
                                                      gradient: const LinearGradient(
                                                        colors: [
                                                          Color(0xFFE97A12),
                                                          Color(0xFFFF8C42),
                                                        ],
                                                      ),
                                                    ),
                                                    child: const Center(
                                                      child: Text(
                                                        'Entrar em Contato',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.w600,
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
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class HelpItem {
  final IconData icon;
  final String title;
  final String description;

  HelpItem({
    required this.icon,
    required this.title,
    required this.description,
  });
}