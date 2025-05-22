import 'package:flutter/material.dart';

class EsocialScreen extends StatefulWidget {
  const EsocialScreen({super.key});

  @override
  State<EsocialScreen> createState() => _EsocialScreenState();
}

class _EsocialScreenState extends State<EsocialScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('eSocial')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [const Text('eSocial')],
        ),
      ),
    );
  }
}
