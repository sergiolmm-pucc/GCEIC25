import 'package:flutter/material.dart';
import 'package:gcseic25/equipes/CI_CD_6/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _senha = TextEditingController();
  String? errorMessage;

  void _login() {
    if (_email.text == "admin@email.com" && _senha.text == "123456") {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    } else {
      setState(() {
        errorMessage = "Email ou senha inválidos";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _email,
              decoration: InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: _senha,
              decoration: InputDecoration(labelText: "Senha"),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text("Entrar"),
            ),
            if (errorMessage != null)
              Text(
                errorMessage!,
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}
