import 'package:flutter/material.dart';
import 'package:gcseic25/equipes/CI_CD_10/home.dart';

class CI_CD10LoginPage extends StatefulWidget {
  const CI_CD10LoginPage({super.key});

  @override
  State<CI_CD10LoginPage> createState() => _CI_CD10LoginPageState();
}

class _CI_CD10LoginPageState extends State<CI_CD10LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _login() {
    if (!_formKey.currentState!.validate()) return;
    if (_emailCtrl.text.trim() == 'admin@gmail.com' &&
        _passCtrl.text == 'admin') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      setState(() => _error = 'Email ou senha inválidos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _emailCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator:
                      (v) =>
                          (v == null || !v.contains('@'))
                              ? 'Digite um email válido'
                              : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Senha',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                  obscureText: true,
                  validator: (v) => (v == null) ? 'Digite uma senha' : null,
                ),
                const SizedBox(height: 20),
                if (_error != null)
                  Text(_error!, style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _login,
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
