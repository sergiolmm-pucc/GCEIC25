import 'package:flutter/material.dart';
import 'package:gcseic25/equipes/CI_CD_6/splash_creen.dart';
import 'package:gcseic25/equipes/equipe4/screens/login.dart';
import 'package:gcseic25/equipes/equipe4/screens/splash_screen.dart';
import 'package:gcseic25/equipes/APOS/screens/splash_screen.dart';
import 'dart:async'; // Para o Timer
import 'package:http/http.dart' as http;
import 'package:gcseic25/equipes/base/base.dart';
import 'package:gcseic25/equipes/CI_CD_8/auth/login.dart' as CI_CD8Login;
import 'package:gcseic25/equipes/CI_CD_8/splashscreen.dart' as CI_CD8Splash;
import 'package:gcseic25/page/markup.dart';
import 'package:gcseic25/page/login.dart';
import 'package:flutter/rendering.dart';
import 'package:gcseic25/equipes/MKP1/screens/splash_screen.dart';
import 'package:gcseic25/equipes/base/equipe3/login_screen.dart';
import 'package:gcseic25/equipes/base/equipe3/splash_screen.dart';
import 'package:gcseic25/equipes/equipe5/screens/login.dart';

import 'package:gcseic25/equipes/CI_CD_10/login.dart';
import 'package:gcseic25/equipes/CI_CD_10/splashscreen.dart' as CI_CD10Splash;


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

        '/splash_screen_equipe_2': (context) => SplashScreen4(nextPage: LoginPage4()),

        '/CI_CD_8': (context) => CI_CD8Splash.SplashScreen(nextPage: const CI_CD8Login.LoginPage()),
        '/CI_CD_6': (context) => SplashToLoginScreen(),

        '/splash1':
            (context) =>
                SplashScreen1(nextPage: ConsultaPage1(title: 'Base 1')),
        '/splash2':
            (context) =>
                SplashScreen(nextPage: ConsultaPage(title: 'Consulta 2')),

        '/CI_CD_10_splash': 
            (context) =>
                CI_CD10Splash.SplashScreen(nextPage: CI_CD10LoginPage(),),

        '/markup': (context) => MultiplierMarkupPage(),
        '/login': (context) => LoginPage(),
        '/aposSplashScreen': (context) => APOSSplashScreen(),
        '/mkp1SplashScreen': (context) => const MKP1SplashScreen(),
        '/mob3': (context) => SplashScreen3(nextPage:  LoginScreen()), 
        '/equipe5': (context) => TelaLogin(),


      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
              onPressed: () {

                Navigator.pushNamed(context, '/CI_CD_10_splash');


                Navigator.pushNamed(context, '/CI_CD_6');
              },
              child: Text('Cálculo do ETEC[CI/CD 6]'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/splash_screen_equipe_2');
              },
              child: Text('Grupo 2 - Cálculo Piscina'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/CI_CD_8'),
              child: const Text('Grupo CI_CD_8'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/mob3');
              },
              child: Text('MOB3'),
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
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/mkp1SplashScreen');
              },
              child: Text('Calculadora de Markup'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/equipe5');
              },
              child: Text('Calculadora de Impostos 5'),
            ),
                        SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/CI_CD_10');

              },
              child: Text('Grupo CI_CD_10'),

            ),
          ],
        ),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  final Widget nextPage;

  const SplashScreen({super.key, required this.nextPage});

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

  const ConsultaPage({super.key, required this.title});

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
