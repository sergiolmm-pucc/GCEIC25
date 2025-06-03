import 'dart:convert';
import 'package:http/http.dart' as http;

class MKP1Service {
  static const String baseUrl = 'https://animated-occipital-buckthorn.glitch.me/mkp1';

  // Cálculo simples de markup
  Future<Map<String, dynamic>> calculoSimples(
    double custo,
    double lucro,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/markup-simples'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'custo': custo, 'lucro': lucro}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Falha ao calcular markup simples');
      }
    } catch (e) {
      throw Exception('Erro ao conectar com o servidor: $e');
    }
  }

  // Cálculo de lucro obtido
  Future<Map<String, dynamic>> lucroObtido(
    double custo,
    double precoVenda,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/lucro-obtido'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'custo': custo, 'precoVenda': precoVenda}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Falha ao calcular lucro obtido');
      }
    } catch (e) {
      throw Exception('Erro ao conectar com o servidor: $e');
    }
  }

  // Cálculo detalhado com despesas e impostos
  Future<Map<String, dynamic>> calculoDetalhado({
    required double custo,
    required double lucro,
    required double despesas,
    required double impostos,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/markup-detalhado'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'custo': custo,
          'lucro': lucro,
          'despesas': despesas,
          'impostos': impostos,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Falha ao calcular markup detalhado');
      }
    } catch (e) {
      throw Exception('Erro ao conectar com o servidor: $e');
    }
  }

  // Sugestão de preço baseado em concorrentes
  Future<Map<String, dynamic>> sugestaoPreco(
    double custo,
    List<double> concorrentes,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/sugestao-preco'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'custo': custo, 'concorrentes': concorrentes}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Falha ao obter sugestão de preço');
      }
    } catch (e) {
      throw Exception('Erro ao conectar com o servidor: $e');
    }
  }
}
