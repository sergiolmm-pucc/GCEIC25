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
    final url = Uri.parse('https://animated-occipital-buckthorn.glitch.me/MOB3/sobre');

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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2196F3), Color(0xFFBBDEFB)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 400),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.arrow_back, color: Colors.blue[700]),
                              onPressed: () => Navigator.pop(context),
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Sobre a Equipe',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[800],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24),
                        if (isLoading)
                          Center(child: CircularProgressIndicator())
                        else ...[
                          CircleAvatar(
                            radius: 60,
                            backgroundImage: imageUrl != null
                                ? NetworkImage(imageUrl!)
                                : AssetImage('image/Imagem teste.jpg') as ImageProvider,
                          ),
                          SizedBox(height: 16),
                          Text(
                            "Equipe MOB 3",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue[900],
                            ),
                          ),
                          Text(
                            "Aplicativo de Cálculo de Piscinas",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.blue[700],
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Resposta da API:',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.blue[800],
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            _resposta,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blue[900],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
