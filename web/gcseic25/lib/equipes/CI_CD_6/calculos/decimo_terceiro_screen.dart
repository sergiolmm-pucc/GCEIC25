import 'package:flutter/material.dart';

class DecimoTerceiroScreen extends StatefulWidget {
  const DecimoTerceiroScreen({super.key});

  @override
  State<DecimoTerceiroScreen> createState() => _DecimoTerceiroScreenState();
}

class _DecimoTerceiroScreenState extends State<DecimoTerceiroScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Decimo Terceiro')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [const Text('Decimo Terceiro')],
        ),
      ),
    );
  }
}
