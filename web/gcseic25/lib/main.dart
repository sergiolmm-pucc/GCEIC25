import 'package:flutter/material.dart';
import 'package:gcseic25/equipes/APOS/screens/splash_screen.dart';
import 'dart:async'; // Para o Timer
import 'package:http/http.dart' as http;
import 'package:gcseic25/equipes/base/base.dart';
import 'package:gcseic25/equipes/CI_CD_8/auth/login.dart' as CI_CD8Login;
import 'package:gcseic25/equipes/CI_CD_8/splashscreen.dart' as CI_CD8Splash;
import 'package:gcseic25/page/markup.dart';
import 'package:gcseic25/page/login.dart';
import 'package:flutter/rendering.dart';
import 'package:gcseic25/equipes/APOS/screens/splash_screen.dart';
import 'package:gcseic25/equipes/base/equipe3/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // required semantics binding
  SemanticsBinding.instance.ensureSemantics();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de Navegação',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
      routes: {

        '/CI_CD_8': (context) => CI_CD8Splash.SplashScreen(nextPage: const CI_CD8Login.LoginPage()),
        '/splash1':
            (context) =>
                SplashScreen1(nextPage: ConsultaPage1(title: 'Base 1')),
        '/splash2':
            (context) =>
                SplashScreen(nextPage: ConsultaPage(title: 'Consulta 2')),
        '/markup': (context) => MultiplierMarkupPage(),
        '/login': (context) => LoginPage(),
        '/aposSplashScreen': (context) => APOSSplashScreen(),
        '/mob3': (context) => SplashScreen(nextPage: LoginScreen()), 
      },
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tela Inicial')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/splash1');
              },
              child: Text('Abrir Base 1'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/splash2');
              },
              child: Text('Abrir Consulta 2'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/CI_CD_8'),
              child: const Text('Grupo CI_CD_8'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/login'),
              child: const Text('MARKUP MULTIPLICADOR'),
            ),
            Semantics(
              // identifier: 'Entrar',
              label: 'Entrar',
              button: true,
              child: SizedBox(
                width: 220,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/splash1');
                  },
                  child: const Text('Entrar'),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/aposSplashScreen');
              },
              child: Text('Calculadora de Aposentadoria'),
            ),
            SizedBox(height: 20),
            Semantics(
              identifier: 'Entrar',
              label: 'Entrar',
              button: true,
              child: SizedBox(
                width: 220,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/aposSplashScreen');
                  },
                  child: const Text('Entrar'),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/mob3');
              },
              child: Text('MOB3'),
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
