import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SobrePage extends StatefulWidget {
  @override
  _SobrePageState createState() => _SobrePageState();
}

class _SobrePageState extends State<SobrePage> {
  List<Map<String, String>> _dados = [];
  bool _carregando = false;

  Future<void> _buscarDados() async {
    setState(() {
      _carregando = true;
      _dados = [];
    });

    await Future.delayed(Duration(seconds: 1)); 

    try {
      final response = await http.get(Uri.parse('https://animated-occipital-buckthorn.glitch.me/MKP2/sobre'));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;

        List<Map<String, String>> lista = [];
        jsonData.entries.toList().asMap().forEach((index, entry) {
          lista.add({
            'nome': entry.key,
            'ra': entry.value.toString(),
            'imagem': 'lib/equipes/CI_CD_8/assets/images/0${index + 1}.jpg',
          });
        });

        setState(() {
          _dados = lista;
        });
      } else {
        setState(() {
          _dados = [
            {'nome': 'Erro ao buscar dados', 'ra': '', 'imagem': ''}
          ];
        });
      }
    } catch (e) {
      setState(() {
        _dados = [
          {'nome': 'Erro ao conectar com o servidor', 'ra': '', 'imagem': ''}
        ];
      });
    }

    setState(() {
      _carregando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sobre'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: _carregando
                  ? Text('Buscando dados...')
                  : _dados.isNotEmpty
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: _dados.map((item) {
                            return Expanded(
                              child: Card(
                                margin: EdgeInsets.symmetric(horizontal: 8),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (item['imagem']!.isNotEmpty)
                                        Image.asset(
                                          item['imagem']!,
                                          width: 150,
                                          height: 150,
                                          fit: BoxFit.cover,
                                        ),
                                      SizedBox(height: 5),
                                      Text(
                                        item['nome'] ?? '',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      Text(
                                        'RA: ${item['ra'] ?? ''}',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                      )
              : SizedBox.shrink(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: Center(
              child: ElevatedButton(
                onPressed: _carregando ? null : _buscarDados,
                child: Text('Carregar Informações'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
