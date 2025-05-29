import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usuario = TextEditingController();
  final _senha = TextEditingController();
  String? erro;

  Future<void> _login() async {
  print('Iniciando login...');
  final url = Uri.parse('https://animated-occipital-buckthorn.glitch.me/MOB3/login');

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': _usuario.text,
        'senha': _senha.text,
      }),
    );

    print('Status code: ${response.statusCode}');
    print('Resposta: ${response.body}');

    if (response.statusCode == 200) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else if (response.statusCode == 401) {
      setState(() {
        erro = 'Usuário ou senha inválidos.';
      });
    } else {
      setState(() {
        erro = 'Erro ao conectar ao servidor.';
      });
    }
  } catch (e) {
    print('Erro durante a requisição: $e');
    setState(() {
      erro = 'Erro inesperado: $e';
    });
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _usuario, decoration: InputDecoration(labelText: 'Usuário')),
            TextField(controller: _senha, obscureText: true, decoration: InputDecoration(labelText: 'Senha')),
            SizedBox(height: 10),
            ElevatedButton(onPressed: _login, child: Text('Entrar')),
            if (erro != null) Text(erro!, style: TextStyle(color: Colors.red))
          ],
        ),
      ),
    );
  }
}
