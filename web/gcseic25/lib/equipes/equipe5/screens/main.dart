import 'login.dart'; // Caminho relativo porque está na mesma pasta
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // required semantics binding
  SemanticsBinding.instance.ensureSemantics();
  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TelaLogin(),
    );
  }
}
