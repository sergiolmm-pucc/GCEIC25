import 'package:flutter/material.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usuario = TextEditingController();
  final _senha = TextEditingController();
  String? erro;

  void _login() {
    if (_usuario.text == 'aluno' && _senha.text == '1234') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      setState(() {
        erro = 'Usuário ou senha inválidos.';
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
