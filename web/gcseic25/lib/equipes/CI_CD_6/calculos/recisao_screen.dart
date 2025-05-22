import 'package:flutter/material.dart';

class RecisaoScreen extends StatefulWidget {
  const RecisaoScreen({super.key});

  @override
  State<RecisaoScreen> createState() => _RecisaoScreenState();
}

class _RecisaoScreenState extends State<RecisaoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recisão')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [const Text('Recisão')],
        ),
      ),
    );
  }
}
