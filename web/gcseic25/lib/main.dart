import 'package:flutter/material.dart';
import 'package:gcseic25/page/login.dart'; // certifique-se de importar corretamente
import 'package:gcseic25/page/markup.dart';
import 'package:gcseic25/equipes/base/base.dart';
import 'package:gcseic25/page/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de Navegação',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LoginPage(), // 👉 inicia no login
      routes: {
        '/home': (context) => HomePage(), // rota para a tela inicial após login
        '/splash1':
            (context) =>
                SplashScreen1(nextPage: ConsultaPage1(title: 'Base 1')),
        '/splash2':
            (context) =>
                SplashScreen(nextPage: ConsultaPage(title: 'Consulta 2')),
        '/markup': (context) => SplashScreen(nextPage: MultiplierMarkupPage()),
      },
    );
  }
}
