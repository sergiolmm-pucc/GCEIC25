import 'package:flutter/material.dart';
import 'dart:async'; // Para o Timer
import 'package:http/http.dart' as http;



class SplashScreen1 extends StatefulWidget {
  final Widget nextPage;

  const SplashScreen1({required this.nextPage});

  @override
  _SplashScreenState1 createState() => _SplashScreenState1();
}

class _SplashScreenState1 extends State<SplashScreen1> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 10), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => widget.nextPage),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Loading...',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

class ConsultaPage1 extends StatefulWidget {
  final String title;

  const ConsultaPage1({required this.title});

  @override
  _ConsultaPageState1 createState() => _ConsultaPageState1();
}

class _ConsultaPageState1 extends State<ConsultaPage1> {
  String _responseText = 'Resultado aparecerá aqui.';

  Future<void> _fetchData() async {
    //
   final response = await http.get(Uri.parse('https://sincere-magnificent-cobweb.glitch.me/users'));
  if (response.statusCode == 200) {
    setState(() {
      _responseText = response.body;
    });
  } else {
    setState(() {
      _responseText = 'Erro ao consultar API.';
    });
  }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _fetchData,
              child: Text('Consultar API'),
            ),
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blueAccent),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                _responseText,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
