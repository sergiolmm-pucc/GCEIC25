import 'dart:ui';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gcseic25/equipes/CI_CD_8/home.dart';

// —— Paleta inspirada no Sebrae, mas com contraste reforçado ——
const kPrimaryBlue = Color(0xFF0057B8);   // Azul principal (mais escuro)
const kAccentBlue  = Color(0xFF0A84FF);   // Azul claro de realce
const kHeaderGradient = [kPrimaryBlue, kAccentBlue];
const kBackground = Color(0xFFEFF3F9);    // Cinza-azulado de fundo

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl  = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _login() async {
  if (!_formKey.currentState!.validate()) return;

  final url = Uri.parse('https://animated-occipital-buckthorn.glitch.me/MKP2/auth'); // ou http://IP_DO_SERVIDOR:PORTA/auth
  final body = jsonEncode({
    'email': _emailCtrl.text.trim(),
    'senha': _passCtrl.text.trim(),
  });

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      if (json['acesso'] == 'liberado') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      } else {
        setState(() => _error = 'Acesso negado');
      }
    } else {
      setState(() => _error = 'Email ou senha inválidos');
    }
  } catch (e) {
    setState(() => _error = 'Erro na conexão: $e');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: Stack(children: [
        // CABEÇALHO GRADIENTE COM CURVA
        _HeaderBanner(),

        // FORMULÁRIO CENTRAL
        Align(
          alignment: const Alignment(0, 0.25),
          child: _LoginCard(
            formKey: _formKey,
            emailCtrl: _emailCtrl,
            passCtrl: _passCtrl,
            error: _error,
            onLogin: _login,
          ),
        ),
      ]),
    );
  }
}

// ================= VIDÊTES AUXILIARES =================

class _HeaderBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _BottomWaveClipper(),
      child: Container(
        height: 280,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: kHeaderGradient,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        alignment: Alignment(0, -0.2),
        child: Text(
          'Bem-vindo!',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
  }
}

class _LoginCard extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailCtrl;
  final TextEditingController passCtrl;
  final String? error;
  final VoidCallback onLogin;

  const _LoginCard({
    required this.formKey,
    required this.emailCtrl,
    required this.passCtrl,
    required this.error,
    required this.onLogin,
  });

  @override
  Widget build(BuildContext context) {
    final cardWidth = MediaQuery.of(context).size.width * 0.85;

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: cardWidth > 500 ? 500 : cardWidth,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.95),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 30,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: emailCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) =>
                      (v == null || !v.contains('@')) ? 'Digite um email válido' : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: passCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Senha',
                    prefixIcon: Icon(Icons.lock_outline),
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (v) =>
                      (v == null || v.length < 6) ? 'Mínimo 6 caracteres' : null,
                ),
                const SizedBox(height: 28),
                if (error != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(error!, style: const TextStyle(color: Colors.red)),
                  ),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryBlue,
                      foregroundColor: Colors.white, // ← CONTRASTE
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 4,
                    ),
                    onPressed: onLogin,
                    child: const Text('Entrar'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// —— Clipper para criar uma suave onda na parte inferior do banner ——
class _BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 60);
    path.quadraticBezierTo(
      size.width * 0.25, size.height,
      size.width * 0.5, size.height,
    );
    path.quadraticBezierTo(
      size.width * 0.75, size.height,
      size.width, size.height - 60,
    );
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}