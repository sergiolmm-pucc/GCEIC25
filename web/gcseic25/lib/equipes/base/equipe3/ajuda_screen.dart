import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AjudaScreen extends StatefulWidget {
  @override
  _AjudaScreenState createState() => _AjudaScreenState();
}

class _AjudaScreenState extends State<AjudaScreen> {
  String textoAjuda = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    carregarAjuda();
  }

  Future<void> carregarAjuda() async {
    final url = Uri.parse('https://animated-occipital-buckthorn.glitch.me/MOB3/ajuda');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          textoAjuda = data['texto'];
          isLoading = false;
        });
      } else {
        setState(() {
          textoAjuda = 'Erro ao carregar ajuda.';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        textoAjuda = 'Erro de conexão com o servidor.';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ajuda')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : Text(
                textoAjuda,
                style: TextStyle(fontSize: 16),
              ),
      ),
    );
  }
}
