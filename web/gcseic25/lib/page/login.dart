// lib/page/login.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  String mensagem = '';

  Future<void> fazerLogin() async {
    final response = await http.post(
      Uri.parse('http://localhost:3000/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': emailController.text,
        'senha': senhaController.text,
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        mensagem = json.decode(response.body)['mensagem'];
      });

      // Redireciona para a HomePage após login bem-sucedido
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      setState(() {
        mensagem = 'Erro: ${json.decode(response.body)['mensagem']}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: senhaController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Senha'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: fazerLogin, child: const Text('Entrar')),
            const SizedBox(height: 16),
            Text(mensagem),
          ],
        ),
      ),
    );
  }
}
