import 'package:flutter/material.dart';
import 'package:gcseic25/equipes/CI_CD_10/calcular.dart';
import 'package:gcseic25/equipes/CI_CD_10/fotogrupoScreen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1A2980), Color(0xFF26D0CE)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 64),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.calculate_outlined,
                    size: 100, color: Colors.white),
                const SizedBox(height: 30),
                const Text(
                  'Cálculo de Encargos Trabalhistas\nEmpregada Doméstica',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 40),
                _GradientButton(
                  text: 'Ir para calculo',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CalcularPage()),
                    );
                  },
                ),
                                const SizedBox(height: 40),
                _GradientButton(
                  text: 'Sobre',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const FotoGrupoScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GradientButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;

  const _GradientButton({
    required this.text,
    required this.onPressed,
  });

  @override
  State<_GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<_GradientButton> {
  bool _hovering = false;

@override
Widget build(BuildContext context) {
  return Semantics(
    label: widget.text, // Isso define o aria-label dinamicamente
    button: true,
    child: MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 220,
        height: 55,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: const LinearGradient(
            colors: [Color(0xFF005AA7), Color(0xFF00CDAC)],
          ),
          boxShadow: _hovering
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                  )
                ]
              : [],
        ),
        child: TextButton(
          onPressed: widget.onPressed,
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: Text(
            widget.text,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    ),
  );
}
}
