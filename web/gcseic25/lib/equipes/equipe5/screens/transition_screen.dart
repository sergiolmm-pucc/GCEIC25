import 'package:flutter/material.dart';
import 'dart:async';

class TransitionScreen extends StatefulWidget {
  final Widget nextPage;

  const TransitionScreen({super.key, required this.nextPage});

  @override
  State<TransitionScreen> createState() => _TransitionScreenState();
}

class _TransitionScreenState extends State<TransitionScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 10), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => widget.nextPage),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Carregando...',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
