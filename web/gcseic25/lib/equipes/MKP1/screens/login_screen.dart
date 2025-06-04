import 'package:flutter/material.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() {
    if (_formKey.currentState!.validate()) {
      if (_usernameController.text == 'admin' &&
          _passwordController.text == 'admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Usuário ou senha inválidos'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900],
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Card(
            margin: const EdgeInsets.all(20),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Semantics(
                      label: 'Ícone da Calculadora de Markup',
                      child: const Icon(Icons.local_bar, size: 80, color: Colors.blue),
                    ),
                    const SizedBox(height: 20),
                    Semantics(
                      identifier: 'Campo Usuário',
                      label: 'Campo de usuário',
                      hint: 'Digite seu usuário',
                      textField: true,
                      child: TextFormField(
                        controller: _usernameController,
                        decoration: const InputDecoration(
                          labelText: 'Usuário',
                          border: OutlineInputBorder(),
                          hintText: 'Digite seu usuário',
                        ),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        autofocus: true,
                        enabled: true,
                        readOnly: false,
                        focusNode: FocusNode(),
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                        onTap: () {
                          _usernameController.selection = TextSelection.fromPosition(
                            TextPosition(offset: _usernameController.text.length),
                          );
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira o usuário';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Semantics(
                      identifier: 'Campo Senha',
                      label: 'Campo de senha',
                      hint: 'Digite sua senha',
                      textField: true,
                      child: TextFormField(
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          labelText: 'Senha',
                          border: OutlineInputBorder(),
                          hintText: 'Digite sua senha',
                        ),
                        keyboardType: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.done,
                        obscureText: true,
                        enabled: true,
                        readOnly: false,
                        focusNode: FocusNode(),
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                        onTap: () {
                          _passwordController.selection = TextSelection.fromPosition(
                            TextPosition(offset: _passwordController.text.length),
                          );
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira a senha';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Semantics(
                          identifier: 'Botão Sobre',
                          label: 'Botão Sobre',
                          button: true,
                          hint: 'Clique para ver informações sobre o aplicativo',
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.info_outline),
                            label: const Text('Sobre'),
                            onPressed: () {
                              Navigator.pushNamed(context, '/sobre');
                            },
                          ),
                        ),
                        Semantics(
                          identifier: 'Botão Ajuda',
                          label: 'Botão Ajuda',
                          button: true,
                          hint: 'Clique para ver a ajuda do aplicativo',
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.help_outline),
                            label: const Text('Ajuda'),
                            onPressed: () {
                              Navigator.pushNamed(context, '/ajuda');
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Semantics(
                      identifier: 'Botão Entrar',
                      label: 'Botão Entrar',
                      button: true,
                      hint: 'Clique para fazer login',
                      child: ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                        ),
                        child: const Text('Entrar'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
