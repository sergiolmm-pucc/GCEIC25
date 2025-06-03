import 'package:flutter/material.dart';
import 'dart:math' as math;

class SobreScreen extends StatefulWidget {
  const SobreScreen({super.key});

  @override
  State<SobreScreen> createState() => _SobreScreenState();
}

class _SobreScreenState extends State<SobreScreen>
    with TickerProviderStateMixin {
  late AnimationController _waveController;
  late AnimationController _floatController;
  late AnimationController _glowController;
  late AnimationController _morphController;
  
  late Animation<double> _waveAnimation;
  late Animation<double> _floatAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _morphAnimation;
  
  final List<Map<String, String>> membros = [
    {
      'nome': 'Arthur',
      'foto': 'lib/equipes/CI_CD_6/assets/arthur.jpeg',
      'role': 'Full Stack Developer',
      'color': '0xFFFF6B35',
    },
    {
      'nome': 'Guilherme',
      'foto': 'lib/equipes/CI_CD_6/assets/guilherme.jpeg',
      'role': 'Full Stack Developer',
      'color': '0xFFE97A12',
    },
    {
      'nome': 'João',
      'foto': 'lib/equipes/CI_CD_6/assets/joão.jpeg',
      'role': 'Full Stack Developer',
      'color': '0xFFFF8C42',
    },
    {
      'nome': 'Vinicius',
      'foto': 'lib/equipes/CI_CD_6/assets/vinicius.jpeg',
      'role': 'Full Stack Developer',
      'color': '0xFFFFB84D',
    },
    {
      'nome': 'Felipe',
      'foto': 'lib/equipes/CI_CD_6/assets/felipe.jpeg',
      'role': 'Full Stack Developer',
      'color': '0xFFFF9500',
    }
  ];

  @override
  void initState() {
    super.initState();
    
    _waveController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );
    _waveAnimation = Tween<double>(begin: 0, end: 2 * math.pi)
        .animate(_waveController);
    
    _floatController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _floatAnimation = Tween<double>(begin: -8, end: 8)
        .animate(CurvedAnimation(parent: _floatController, curve: Curves.easeInOut));
    
    _glowController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _glowAnimation = Tween<double>(begin: 0.3, end: 1.0)
        .animate(CurvedAnimation(parent: _glowController, curve: Curves.easeInOut));
    
    _morphController = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    );
    _morphAnimation = Tween<double>(begin: 0, end: 1)
        .animate(_morphController);
    
    _waveController.repeat();
    _floatController.repeat(reverse: true);
    _glowController.repeat(reverse: true);
    _morphController.repeat();
  }

  @override
  void dispose() {
    _waveController.dispose();
    _floatController.dispose();
    _glowController.dispose();
    _morphController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Sobre',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _waveAnimation,
          _floatAnimation,
          _glowAnimation,
          _morphAnimation,
        ]),
        builder: (context, child) {
          return Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.topCenter,
                radius: 1.5,
                colors: [
                  Color(0xFF1A1A1A),
                  Color(0xFF0A0A0A),
                  Color(0xFF000000),
                ],
              ),
            ),
            child: Stack(
              children: [
                // Background animated blobs
                ...List.generate(3, (index) {
                  return Positioned(
                    top: 100 + (index * 200) + math.sin(_waveAnimation.value + index) * 50,
                    left: 50 + (index * 80) + math.cos(_waveAnimation.value + index) * 40,
                    child: Container(
                      width: 120 + (index * 20),
                      height: 120 + (index * 20),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Color(int.parse(membros[index % membros.length]['color']!))
                                .withOpacity(0.1 * _glowAnimation.value),
                            Color(int.parse(membros[index % membros.length]['color']!))
                                .withOpacity(0.05 * _glowAnimation.value),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  );
                }),
                
                // Main content
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        const SizedBox(height: 120),
                        
                        // Header com efeito moderno
                        Transform.translate(
                          offset: Offset(0, _floatAnimation.value * 0.5),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(32),
                              color: Colors.white.withOpacity(0.05),
                              border: Border.all(
                                color: const Color(0xFFE97A12).withOpacity(0.3),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFE97A12).withOpacity(0.2),
                                  blurRadius: 32,
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                ShaderMask(
                                  shaderCallback: (bounds) => LinearGradient(
                                    colors: [
                                      const Color(0xFFE97A12),
                                      const Color(0xFFFFB84D),
                                      const Color(0xFFFF6B35),
                                    ],
                                    stops: [
                                      _morphAnimation.value,
                                      (_morphAnimation.value + 0.5) % 1.0,
                                      (_morphAnimation.value + 1.0) % 1.0,
                                    ],
                                  ).createShader(bounds),
                                  child: const Text(
                                    'CI/CD TEAM 6',
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                      letterSpacing: 2,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  height: 2,
                                  width: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(1),
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFFE97A12),
                                        Color(0xFFFFB84D),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                              ],
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 60),
                        
                        // Team members com design moderno
                        ...membros.asMap().entries.map((entry) {
                          int index = entry.key;
                          Map<String, String> membro = entry.value;
                          Color memberColor = Color(int.parse(membro['color']!));
                          
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 24),
                            child: Transform.translate(
                              offset: Offset(
                                math.sin(_waveAnimation.value + index * 0.5) * 6,
                                _floatAnimation.value * (0.3 + index * 0.1),
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  // Adicionar interação se necessário
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(24),
                                    color: Colors.white.withOpacity(0.03),
                                    border: Border.all(
                                      color: memberColor.withOpacity(0.2),
                                      width: 1,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: memberColor.withOpacity(0.1 * _glowAnimation.value),
                                        blurRadius: 24,
                                        spreadRadius: 0,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      // Avatar com efeito glow
                                      Container(
                                        padding: const EdgeInsets.all(3),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: LinearGradient(
                                            colors: [
                                              memberColor.withOpacity(0.8),
                                              memberColor.withOpacity(0.4),
                                            ],
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: memberColor.withOpacity(0.4 * _glowAnimation.value),
                                              blurRadius: 20,
                                              spreadRadius: 2,
                                            ),
                                          ],
                                        ),
                                        child: Container(
                                          padding: const EdgeInsets.all(2),
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color(0xFF0A0A0A),
                                          ),
                                          child: CircleAvatar(
                                            radius: 32,
                                            backgroundImage: AssetImage(membro['foto']!),
                                          ),
                                        ),
                                      ),
                                      
                                      const SizedBox(width: 20),
                                      
                                      // Info do membro
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              membro['nome']!,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              membro['role']!,
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: memberColor.withOpacity(0.8),
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      
                                      // Indicator animado
                                      Transform.rotate(
                                        angle: _waveAnimation.value * 0.5,
                                        child: Container(
                                          width: 8,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: memberColor,
                                            boxShadow: [
                                              BoxShadow(
                                                color: memberColor.withOpacity(0.6),
                                                blurRadius: 8,
                                                spreadRadius: 1,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                        
                        const SizedBox(height: 40),
                        
                        const SizedBox(height: 60),
                      ],
                    ),
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