import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:gcseic25/equipes/equipe2/screens/home.dart'; // Certifique-se de ter essa tela

class LoginPage2 extends StatefulWidget {
  const LoginPage2({super.key});

  @override
  State<LoginPage2> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage2> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

  bool loading = false;
  String? erro;

  Future<void> fazerLogin() async {
    setState(() {
      loading = true;
      erro = null;
    });

  final url = Uri.parse('http://localhost:3000/CCP/login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': emailController.text.trim(),
          'senha': senhaController.text.trim(),
        }),
      );

      final data = json.decode(response.body);
      if (response.statusCode == 200 && data['sucesso'] == true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen2()),
        );
      } else {
        setState(() {
          erro = data['mensagem'] ?? 'Erro ao fazer login.';
        });
      }
    } catch (e) {
      setState(() {
        erro = 'Erro de conexão. Verifique sua internet.';
      });
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(
              'assets/equipe2/background_login_equipe2.png',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 80),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/equipe2/splash_icon.png', 
                    height: 160,
                  ),
                  Image.asset('assets/equipe2/logo_equipe_2.png', height: 100),
                  const SizedBox(height: 20),
                  Container(
                    width: 350,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Bem-vindo de volta!',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Entre com suas credenciais.',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),

                        const Text('E-mail', style: TextStyle(color: Colors.white)),
                        const SizedBox(height: 4),
                        TextField(
                          controller: emailController,
                          style: const TextStyle(color: Color.fromARGB(255, 105, 105, 105)),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.9),
                            hintText: 'E-mail',
                            hintStyle: const TextStyle(color: Color(0xFFADADAD)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        const Text('Senha', style: TextStyle(color: Colors.white)),
                        const SizedBox(height: 4),
                        TextField(
                          controller: senhaController,
                          obscureText: true,
                          style: const TextStyle(color: Color.fromARGB(255, 105, 105, 105)),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.9),
                            hintText: 'Senha',
                            hintStyle: const TextStyle(color: Color(0xFFADADAD)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        if (erro != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Text(
                              erro!,
                              style: const TextStyle(color: Colors.redAccent),
                              textAlign: TextAlign.center,
                            ),
                          ),

                        ElevatedButton(
                          onPressed: loading ? null : fazerLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: loading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text('LOGIN', style: TextStyle(fontSize: 16)),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          ),
        ],
      ),
    );
  }
}
