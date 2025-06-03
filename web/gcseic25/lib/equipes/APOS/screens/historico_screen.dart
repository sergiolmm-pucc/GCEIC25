import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HistoricoScreen extends StatefulWidget {
  const HistoricoScreen({Key? key}) : super(key: key);

  @override
  _HistoricoScreenState createState() => _HistoricoScreenState();
}

class _HistoricoScreenState extends State<HistoricoScreen> {
  List<dynamic> historico = [];
  bool isLoading = true;
  String? filtroTipo;

  @override
  void initState() {
    super.initState();
    fetchHistorico();
  }

  Future<void> fetchHistorico({String? tipo}) async {
    setState(() => isLoading = true);

    final uri = Uri.parse('https://animated-occipital-buckthorn.glitch.me/APOS/historico')
        .replace(queryParameters: tipo != null ? {'tipo': tipo} : null);

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        historico = data['historico'];
        isLoading = false;
      });
    } else {
      setState(() {
        historico = [];
        isLoading = false;
      });
    }
  }

  Widget buildItem(Map<String, dynamic> op) {
    IconData icon = Icons.history;
    Color color = Colors.blue;

    switch (op['tipo']) {
      case '/calculoAposentadoria':
        icon = Icons.accessibility_new;
        color = Colors.teal;
        break;
      case '/calculoRegra':
        icon = Icons.rule;
        color = Colors.deepPurple;
        break;
      case '/calculoPontuacao':
        icon = Icons.score;
        color = Colors.orange;
        break;
      case '/calculoTempoAposentadoria':
        icon = Icons.timer;
        color = Colors.pink;
        break;
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.15),
          child: Icon(icon, color: color),
        ),
        title: Text(
          op['tipo'],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text("📤 Dados: ${jsonEncode(op['dados'])}"),
            const SizedBox(height: 2),
            Text("📥 Resultado: ${jsonEncode(op['resultado'])}"),
            const SizedBox(height: 2),
            Text("🕒 ${op['timestamp']}", style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget buildDropdownFiltro() {
    final tipos = [
      "/calculoAposentadoria",
      "/calculoRegra",
      "/calculoPontuacao",
      "/calculoTempoAposentadoria"
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: "Filtrar por tipo",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: filtroTipo,
            isExpanded: true,
            hint: const Text("Escolha um tipo"),
            onChanged: (String? newTipo) {
              setState(() => filtroTipo = newTipo);
              fetchHistorico(tipo: newTipo);
            },
            items: tipos.map((String tipo) {
              return DropdownMenuItem<String>(
                value: tipo,
                child: Text(tipo),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Histórico de Operações"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => fetchHistorico(tipo: filtroTipo),
          )
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          const SizedBox(height: 10),
          buildDropdownFiltro(),
          const SizedBox(height: 10),
          Expanded(
            child: historico.isEmpty
                ? const Center(child: Text("Nenhuma operação registrada."))
                : ListView.builder(
              itemCount: historico.length,
              itemBuilder: (context, index) =>
                  buildItem(historico[index]),
            ),
          ),
        ],
      ),
    );
  }
}
