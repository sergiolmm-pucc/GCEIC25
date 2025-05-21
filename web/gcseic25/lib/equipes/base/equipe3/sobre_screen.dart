import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SobreScreen extends StatefulWidget {
  @override
  _SobreScreenState createState() => _SobreScreenState();
}

class _SobreScreenState extends State<SobreScreen> {
  String? imageUrl;
  bool isLoading = true;
  String _resposta = '';

  @override
  void initState() {
    super.initState();
    _consultarSobreAPI();
  }

  Future<void> _consultarSobreAPI() async {
    final url = Uri.parse('http://10.0.2.2:3000/MOB3/sobre'); // Para emulador Android

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
    );

    setState(() {
      _resposta = response.statusCode == 200 ? response.body : 'Erro na requisição';
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        imageUrl = data['url'];
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      print('Erro: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sobre a Equipe')),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: imageUrl != null
                        ? NetworkImage(imageUrl!)
                        : AssetImage('assets/foto.png') as ImageProvider,
                  ),
                  SizedBox(height: 16),
                  Text("Equipe MOB 3", style: TextStyle(fontSize: 18)),
                  Text("Aplicativo de Cálculo de Piscinas"),
                  SizedBox(height: 20),
                  Text('Resposta da API:'),
                  Text(_resposta),
                ],
              ),
      ),
    );
  }
}
