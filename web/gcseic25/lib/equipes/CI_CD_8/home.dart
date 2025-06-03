import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gcseic25/equipes/CI_CD_8/multiplier-markup.dart';
import 'package:gcseic25/equipes/CI_CD_8/divisor_markup.dart';
import 'package:gcseic25/equipes/CI_CD_8/sobre.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String titulo = 'Carregando...';
  String sobreMarkup = '';

  Future<void> retornarHome() async {
    try {
      final response = await http.get(Uri.parse('https://animated-occipital-buckthorn.glitch.me/MKP2/home'));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;

        setState(() {
          titulo = jsonData['titulo'] ?? 'Título indisponível';
          sobreMarkup = jsonData['sobreMarkup'] ?? 'Informações indisponíveis';
        });
      } else {
        throw Exception('Erro ao carregar dados: código ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao buscar home: $e');
      setState(() {
        titulo = 'Erro ao carregar título';
        sobreMarkup = 'Erro ao carregar informações.';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    retornarHome();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F6FC),
      body: Stack(
        children: [
          // Topo azul curvo com título dinâmico
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: _CurvedHeaderClipper(),
              child: Container(
                height: 300,
                color: const Color(0xFF007BFF),
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(top: 60),
                  child: Text(
                    titulo,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),

          // Conteúdo central com botões
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 360),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Selecione uma opção:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    _buildHomeButton(
                      context,
                      label: 'Calculadora de Markup',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MultiplierMarkupPage()),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildHomeButton(
                      context,
                      label: 'Calculadora de Divisão de Markup',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => DivisorMarkupPage()),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildHomeButton(
                      context,
                      label: 'Sobre',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SobrePage()),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),

          // Texto inferior com informações sobre o cálculo de markup
          Positioned(
            left: 32,
            right: 32,
            bottom: 40,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                sobreMarkup,
                style: const TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHomeButton(BuildContext context,
      {required String label, required VoidCallback onPressed}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF007BFF),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class _CurvedHeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 80);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 80);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
