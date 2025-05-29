import 'package:flutter/material.dart';
import '../services/mkp1_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _mkp1Service = MKP1Service();

  // Controllers para o cálculo simples
  final _custoController = TextEditingController();
  final _lucroController = TextEditingController();

  // Controllers para o cálculo detalhado
  final _despesasController = TextEditingController();
  final _impostosController = TextEditingController();

  // Controllers para sugestão de preço
  final _concorrentesController = TextEditingController();

  // Estado da aplicação
  bool _isLoading = false;
  String? _errorMessage;
  Map<String, dynamic>? _resultado;
  String _tipoCalculo = 'simples'; // simples, detalhado, sugestao

  Future<void> _calcularSimples() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        final custo = double.parse(_custoController.text);
        final lucro = double.parse(_lucroController.text);

        final resultado = await _mkp1Service.calculoSimples(custo, lucro);

        setState(() {
          _resultado = resultado;
        });
      } catch (e) {
        setState(() {
          _errorMessage = e.toString();
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _calcularDetalhado() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        final custo = double.parse(_custoController.text);
        final lucro = double.parse(_lucroController.text);
        final despesas = double.parse(_despesasController.text);
        final impostos = double.parse(_impostosController.text);

        final resultado = await _mkp1Service.calculoDetalhado(
          custo: custo,
          lucro: lucro,
          despesas: despesas,
          impostos: impostos,
        );

        setState(() {
          _resultado = resultado;
        });
      } catch (e) {
        setState(() {
          _errorMessage = e.toString();
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _calcularSugestao() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        final custo = double.parse(_custoController.text);
        final concorrentes =
            _concorrentesController.text
                .split(',')
                .map((e) => double.parse(e.trim()))
                .toList();

        final resultado = await _mkp1Service.sugestaoPreco(custo, concorrentes);

        setState(() {
          _resultado = resultado;
        });
      } catch (e) {
        setState(() {
          _errorMessage = e.toString();
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildCalculoSimples() {
    return Column(
      children: [
        TextFormField(
          controller: _custoController,
          decoration: const InputDecoration(
            labelText: 'Custo do Produto (R\$)',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, insira o custo';
            }
            if (double.tryParse(value) == null) {
              return 'Por favor, insira um número válido';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: _lucroController,
          decoration: const InputDecoration(
            labelText: 'Lucro Desejado (%)',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, insira o lucro';
            }
            if (double.tryParse(value) == null) {
              return 'Por favor, insira um número válido';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildCalculoDetalhado() {
    return Column(
      children: [
        TextFormField(
          controller: _custoController,
          decoration: const InputDecoration(
            labelText: 'Custo do Produto (R\$)',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, insira o custo';
            }
            if (double.tryParse(value) == null) {
              return 'Por favor, insira um número válido';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: _lucroController,
          decoration: const InputDecoration(
            labelText: 'Lucro Desejado (%)',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, insira o lucro';
            }
            if (double.tryParse(value) == null) {
              return 'Por favor, insira um número válido';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: _despesasController,
          decoration: const InputDecoration(
            labelText: 'Despesas (%)',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, insira as despesas';
            }
            if (double.tryParse(value) == null) {
              return 'Por favor, insira um número válido';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: _impostosController,
          decoration: const InputDecoration(
            labelText: 'Impostos (%)',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, insira os impostos';
            }
            if (double.tryParse(value) == null) {
              return 'Por favor, insira um número válido';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildSugestaoPreco() {
    return Column(
      children: [
        TextFormField(
          controller: _custoController,
          decoration: const InputDecoration(
            labelText: 'Custo do Produto (R\$)',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, insira o custo';
            }
            if (double.tryParse(value) == null) {
              return 'Por favor, insira um número válido';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: _concorrentesController,
          decoration: const InputDecoration(
            labelText: 'Preços dos Concorrentes (separados por vírgula)',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, insira os preços dos concorrentes';
            }
            try {
              value.split(',').forEach((e) => double.parse(e.trim()));
              return null;
            } catch (e) {
              return 'Por favor, insira números válidos separados por vírgula';
            }
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora de Markup'),
        backgroundColor: Colors.blue[900],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.local_bar, size: 80, color: Colors.blue),
              const SizedBox(height: 20),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'simples', label: Text('Simples')),
                  ButtonSegment(value: 'detalhado', label: Text('Detalhado')),
                  ButtonSegment(value: 'sugestao', label: Text('Sugestão')),
                ],
                selected: {_tipoCalculo},
                onSelectionChanged: (Set<String> newSelection) {
                  setState(() {
                    _tipoCalculo = newSelection.first;
                    _resultado = null;
                  });
                },
              ),
              const SizedBox(height: 20),
              if (_tipoCalculo == 'simples') _buildCalculoSimples(),
              if (_tipoCalculo == 'detalhado') _buildCalculoDetalhado(),
              if (_tipoCalculo == 'sugestao') _buildSugestaoPreco(),
              const SizedBox(height: 20),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ElevatedButton(
                onPressed:
                    _isLoading
                        ? null
                        : () {
                          switch (_tipoCalculo) {
                            case 'simples':
                              _calcularSimples();
                              break;
                            case 'detalhado':
                              _calcularDetalhado();
                              break;
                            case 'sugestao':
                              _calcularSugestao();
                              break;
                          }
                        },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                child:
                    _isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Calcular'),
              ),
              const SizedBox(height: 30),
              if (_resultado != null) ...[
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Text(
                          'Resultado',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        if (_tipoCalculo == 'simples' ||
                            _tipoCalculo == 'detalhado')
                          Text(
                            'Preço de Venda: R\$ ${_resultado!['precoVenda']}',
                            style: const TextStyle(fontSize: 18),
                          ),
                        if (_tipoCalculo == 'sugestao')
                          Text(
                            'Preço Sugerido: R\$ ${_resultado!['precoSugerido']}',
                            style: const TextStyle(fontSize: 18),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _custoController.dispose();
    _lucroController.dispose();
    _despesasController.dispose();
    _impostosController.dispose();
    _concorrentesController.dispose();
    super.dispose();
  }
}
