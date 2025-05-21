import 'package:flutter/material.dart';

class SobreScreen extends StatefulWidget {
  const SobreScreen({super.key});

  @override
  State<SobreScreen> createState() => _SobreScreenState();
}

class _SobreScreenState extends State<SobreScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sobre'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Sobre'),
          ],
        ),
      ),
    );
  }
}
