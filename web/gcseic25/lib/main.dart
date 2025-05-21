import 'package:flutter/material.dart';
import 'dart:async'; // Para o Timer
import 'package:http/http.dart' as http;
import 'package:gcseic25/equipes/base/base.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de Navegação',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
      routes: {
        '/splash1':
            (context) =>
                SplashScreen1(nextPage: ConsultaPage1(title: 'Base 1')),
        '/splash2':
            (context) =>
                SplashScreen(nextPage: ConsultaPage(title: 'Consulta 2')),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tarefa CI/CD - Grupo 10'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Cálculo de Encargos trabalhistas - Empregada doméstica',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: const Text('Login'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/help');
              },
              child: const Text('Ajuda'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/equipe');
              },
              child: const Text('Equipe'),
            ),
          ],
        ),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  final Widget nextPage;

  const SplashScreen({required this.nextPage});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 10), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => widget.nextPage),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Carregando...', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}

class ConsultaPage extends StatefulWidget {
  final String title;

  const ConsultaPage({required this.title});

  @override
  _ConsultaPageState createState() => _ConsultaPageState();
}

class _ConsultaPageState extends State<ConsultaPage> {
  String _responseText = 'Resultado aparecerá aqui.';

  Future<void> _fetchData() async {
    //
    final response = await http.get(
      Uri.parse('https://animated-occipital-buckthorn.glitch.me/datetime'),
    );
    if (response.statusCode == 200) {
      setState(() {
        _responseText = response.body;
      });
    } else {
      setState(() {
        _responseText = 'Erro ao consultar API.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(onPressed: _fetchData, child: Text('Consultar API')),
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blueAccent),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(_responseText, style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
