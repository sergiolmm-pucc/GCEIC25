import 'package:flutter/material.dart';
import 'splash_screen.dart'; // ajuste conforme seu projeto


class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key});

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  String? erro;

  void fazerLogin() {
    const emailCorreto = 'adm@email.com';
    const senhaCorreta = 'qwerty';

    if (_emailController.text == emailCorreto &&
        _senhaController.text == senhaCorreta) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SplashScreen(),
        ),
      );
    } else {
      setState(() {
        erro = 'Email ou senha inválidos!';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0D47A1), // Azul escuro
              Colors.white,      // Branco
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 32.0),
                child: Text(
                  'Bem-vindo à Calculadora de Impostos',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                width: 350,
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Login',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 24),

                    // Campo de Email
                    Semantics(
                      label: 'Campo de email',
                      hint: 'Digite seu email',
                      textField: true,
                      child: TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(labelText: 'Email'),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Campo de Senha
                    Semantics(
                      label: 'Campo de senha',
                      hint: 'Digite sua senha',
                      textField: true,
                      child: TextField(
                        controller: _senhaController,
                        decoration: const InputDecoration(labelText: 'Senha'),
                        obscureText: true,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Botão Entrar
                    Semantics(
                      label: 'Botão Entrar',
                      button: true,
                      hint: 'Pressione para fazer login',
                      child: ElevatedButton(
                        onPressed: fazerLogin,
                        child: const Text('Entrar'),
                      ),
                    ),

                    if (erro != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        erro!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
