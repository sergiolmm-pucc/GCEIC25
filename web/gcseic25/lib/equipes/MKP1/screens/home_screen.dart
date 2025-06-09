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

  // Controllers para lucro obtido
  final _precoVendaController = TextEditingController();

  // Estado da aplicação
  bool _isLoading = false;
  String? _errorMessage;
  Map<String, dynamic>? _resultado;
  String _tipoCalculo = 'simples'; // simples, detalhado, sugestao, simulacao, lucroObtido

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

  Future<void> _calcularSimulacao() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        final custo = double.parse(_custoController.text);
        final despesas = double.parse(_despesasController.text);
        final impostos = double.parse(_impostosController.text);

        final resultado = await _mkp1Service.simulacao(
          custo: custo,
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

  Future<void> _calcularLucroObtido() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        final custo = double.parse(_custoController.text);
        final precoVenda = double.parse(_precoVendaController.text);

        final resultado = await _mkp1Service.lucroObtido(custo, precoVenda);

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
        Semantics(
          label: 'Campo Custo do Produto',
          textField: true,
          child: TextFormField(
            controller: _custoController,
            decoration: const InputDecoration(
              labelText: 'Custo do Produto (R\$)',
              hintText: 'Custo',
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
        ),
        const SizedBox(height: 20),
        Semantics(
          label: 'Campo Lucro Desejado',
          textField: true,
          child: TextFormField(
            controller: _lucroController,
            decoration: const InputDecoration(
              labelText: 'Lucro Desejado (%)',
              hintText: 'Lucro',
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
        ),
      ],
    );
  }

  Widget _buildCalculoDetalhado() {
    return Column(
      children: [
        Semantics(
          label: 'Campo Custo do Produto',
          textField: true,
          child: TextFormField(
            controller: _custoController,
            decoration: const InputDecoration(
              labelText: 'Custo do Produto (R\$)',
              hintText: 'Custo',
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
        ),
        const SizedBox(height: 20),
        Semantics(
          label: 'Campo Lucro Desejado',
          textField: true,
          child: TextFormField(
            controller: _lucroController,
            decoration: const InputDecoration(
              labelText: 'Lucro Desejado (%)',
              hintText: 'Lucro',
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
        ),
        const SizedBox(height: 20),
        Semantics(
          label: 'Campo Despesas',
          textField: true,
          child: TextFormField(
            controller: _despesasController,
            decoration: const InputDecoration(
              labelText: 'Despesas (%)',
              hintText: 'Despesas',
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
        ),
        const SizedBox(height: 20),
        Semantics(
          label: 'Campo Impostos',
          textField: true,
          child: TextFormField(
            controller: _impostosController,
            decoration: const InputDecoration(
              labelText: 'Impostos (%)',
              hintText: 'Impostos',
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
        ),
      ],
    );
  }

  Widget _buildSugestaoPreco() {
    return Column(
      children: [
        Semantics(
          label: 'Campo Custo do Produto',
          textField: true,
          child: TextFormField(
            controller: _custoController,
            decoration: const InputDecoration(
              labelText: 'Custo do Produto (R\$)',
              hintText: 'Custo',
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
        ),
        const SizedBox(height: 20),
        Semantics(
          label: 'Campo Preços dos Concorrentes',
          textField: true,
          child: TextFormField(
            controller: _concorrentesController,
            decoration: const InputDecoration(
              labelText: 'Preços dos Concorrentes (separados por vírgula)',
              hintText: 'Concorrentes',
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
        ),
      ],
    );
  }

  Widget _buildSimulacao() {
    return Column(
      children: [
        Semantics(
          label: 'Campo Custo do Produto',
          textField: true,
          child: TextFormField(
            controller: _custoController,
            decoration: const InputDecoration(
              labelText: 'Custo do Produto (R\$)',
              hintText: 'Custo',
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
        ),
        const SizedBox(height: 20),
        Semantics(
          label: 'Campo Despesas',
          textField: true,
          child: TextFormField(
            controller: _despesasController,
            decoration: const InputDecoration(
              labelText: 'Despesas (%)',
              hintText: 'Despesas',
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
        ),
        const SizedBox(height: 20),
        Semantics(
          label: 'Campo Impostos',
          textField: true,
          child: TextFormField(
            controller: _impostosController,
            decoration: const InputDecoration(
              labelText: 'Impostos (%)',
              hintText: 'Impostos',
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
        ),
      ],
    );
  }

  Widget _buildLucroObtido() {
    return Column(
      children: [
        Semantics(
          label: 'Campo Custo do Produto',
          textField: true,
          child: TextFormField(
            controller: _custoController,
            decoration: const InputDecoration(
              labelText: 'Custo do Produto (R\$)',
              hintText: 'Custo',
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
        ),
        const SizedBox(height: 20),
        Semantics(
          label: 'Campo Preço de Venda',
          textField: true,
          child: TextFormField(
            controller: _precoVendaController,
            decoration: const InputDecoration(
              labelText: 'Preço de Venda (R\$)',
              hintText: 'Preço de Venda',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, insira o preço de venda';
              }
              if (double.tryParse(value) == null) {
                return 'Por favor, insira um número válido';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildResultado() {
    if (_resultado == null) return const SizedBox.shrink();

    if (_tipoCalculo == 'simulacao') {
      final simulacoes = _resultado!['simulacoes'] as List?;
      if (simulacoes == null) return const SizedBox.shrink();
      
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Resultados da Simulação:',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 16),
          ...simulacoes.map((simulacao) => Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListTile(
                  title: Text(
                    'Margem de Lucro: ${simulacao['Margem de Lucro']}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Preço de Venda: R\$ ${simulacao['Preço de Venda']}',
                    style: const TextStyle(color: Colors.green),
                  ),
                ),
              )),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Resultado:',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 16),
        ..._resultado!.entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                Text(
                  '${entry.key}:',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${entry.value}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora de Markup'),
        backgroundColor: Colors.blue[900],
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              Navigator.pushNamed(context, '/ajuda');
            },
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              Navigator.pushNamed(context, '/sobre');
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue[900]!,
              Colors.blue[700]!,
            ],
          ),
        ),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Semantics(
                              label: 'Segmentos de funcionalidade',
                              child: SegmentedButton<String>(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                                      if (states.contains(MaterialState.selected)) {
                                        return Colors.blue[900]!;
                                      }
                                      return Colors.grey[200]!;
                                    },
                                  ),
                                  foregroundColor: MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                                      if (states.contains(MaterialState.selected)) {
                                        return Colors.white;
                                      }
                                      return Colors.black87;
                                    },
                                  ),
                                  splashFactory: NoSplash.splashFactory,
                                ),
                                showSelectedIcon: false,
                                segments: [
                                  ButtonSegment(
                                    value: 'simples',
                                    label: Semantics(
                                      label: 'Simples',
                                      button: true,
                                      child: const Text('Simples'),
                                    ),
                                  ),
                                  ButtonSegment(
                                    value: 'detalhado',
                                    label: Semantics(
                                      label: 'Detalhado',
                                      button: true,
                                      child: const Text('Detalhado'),
                                    ),
                                  ),
                                  ButtonSegment(
                                    value: 'sugestao',
                                    label: Semantics(
                                      label: 'Sugestão',
                                      button: true,
                                      child: const Text('Sugestão'),
                                    ),
                                  ),
                                  ButtonSegment(
                                    value: 'simulacao',
                                    label: Semantics(
                                      label: 'Simulação',
                                      button: true,
                                      child: const Text('Simulação'),
                                    ),
                                  ),
                                  ButtonSegment(
                                    value: 'lucroObtido',
                                    label: Semantics(
                                      label: 'Lucro Obtido',
                                      button: true,
                                      child: const Text('Lucro Obtido'),
                                    ),
                                  ),
                                ],
                                selected: {_tipoCalculo},
                                onSelectionChanged: (Set<String> newSelection) {
                                  setState(() {
                                    _tipoCalculo = newSelection.first;
                                    _resultado = null;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(height: 24),
                            if (_tipoCalculo == 'simples') _buildCalculoSimples(),
                            if (_tipoCalculo == 'detalhado') _buildCalculoDetalhado(),
                            if (_tipoCalculo == 'sugestao') _buildSugestaoPreco(),
                            if (_tipoCalculo == 'simulacao') _buildSimulacao(),
                            if (_tipoCalculo == 'lucroObtido') _buildLucroObtido(),
                            const SizedBox(height: 24),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue[900],
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 32),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 4,
                                minimumSize: const Size(double.infinity, 60),
                                splashFactory: NoSplash.splashFactory,
                              ),
                              onPressed: _isLoading
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
                                        case 'simulacao':
                                          _calcularSimulacao();
                                          break;
                                        case 'lucroObtido':
                                          _calcularLucroObtido();
                                          break;
                                      }
                                    },
                              child: _isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    )
                                  : const Text(
                                      'Calcular',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (_errorMessage != null) ...[
                      const SizedBox(height: 16),
                      Card(
                        elevation: 4,
                        color: Colors.red.shade50,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Icon(Icons.error_outline, color: Colors.red.shade900),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  _errorMessage!,
                                  style: TextStyle(color: Colors.red.shade900),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    if (_resultado != null) ...[
                      const SizedBox(height: 16),
                      Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: _buildResultado(),
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
    );
  }

  @override
  void dispose() {
    _custoController.dispose();
    _lucroController.dispose();
    _despesasController.dispose();
    _impostosController.dispose();
    _concorrentesController.dispose();
    _precoVendaController.dispose();
    super.dispose();
  }
}
