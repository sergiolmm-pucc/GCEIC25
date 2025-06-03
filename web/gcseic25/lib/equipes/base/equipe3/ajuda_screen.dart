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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.arrow_back, color: Colors.blue[700]),
                              onPressed: () => Navigator.pop(context),
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Ajuda',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[800],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        isLoading
                            ? Center(child: CircularProgressIndicator(color: Colors.blue[700]))
                            : Text(
                                textoAjuda,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.blue[900],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
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
