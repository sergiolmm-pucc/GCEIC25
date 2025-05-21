import 'package:flutter/material.dart';
import 'package:gcseic25/equipes/CI_CD_6/help_screen.dart';
import 'package:gcseic25/equipes/CI_CD_6/sobre_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Bem-vindo à tela inicial!'),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SobreScreen()));
                },
                child: Text('Sobre')),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HelpScreen()));
                },
                child: Text('Ajuda'))
          ],
        ),
      ),
    );
  }
}
