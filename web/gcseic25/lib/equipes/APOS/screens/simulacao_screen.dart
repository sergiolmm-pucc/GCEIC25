import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SimulacaoScreen extends StatefulWidget {
  const SimulacaoScreen({super.key});

  @override
  State<SimulacaoScreen> createState() => _SimulacaoScreenState();
}

class _SimulacaoScreenState extends State<SimulacaoScreen> {
  final _idadeController = TextEditingController();
  final _contribuicaoController = TextEditingController();

  String? _sexoSelecionado; // "M" ou "F"

  String _resultadoMensagem = '';
  bool _podeAposentar = false;
  bool _isLoading = false;

  // URL do seu backend Node.js.
  final String _backendUrl = 'https://animated-occipital-buckthorn.glitch.me';

  @override
  void dispose() {
    _idadeController.dispose();
    _contribuicaoController.dispose();
    super.dispose();
  }

  // Adaptação da função de validação do CalculoScreen
  bool _validarCampos() {
    final idade = int.tryParse(_idadeController.text);
    final contribuicao = int.tryParse(_contribuicaoController.text);

    if (_sexoSelecionado == null) {
      setState(() {
        _resultadoMensagem = 'Por favor, selecione o sexo.';
        _podeAposentar = false;
      });
      return false;
    }

    if (idade == null || contribuicao == null) {
      setState(() {
        _resultadoMensagem = 'Preencha os campos com números válidos.';
        _podeAposentar = false;
      });
      return false;
    }
    if (idade <= 0) {
      setState(() {
        _resultadoMensagem = 'Idade deve ser maior que zero.';
        _podeAposentar = false;
      });
      return false;
    }
    if (idade > 120) {
      setState(() {
        _resultadoMensagem = 'Idade inválida.';
        _podeAposentar = false;
      });
      return false;
    }
    if (contribuicao < 0) {
      setState(() {
        _resultadoMensagem = 'Contribuição não pode ser negativa.';
        _podeAposentar = false;
      });
      return false;
    }
    if (contribuicao > idade) {
      setState(() {
        _resultadoMensagem = 'Contribuição não pode ser maior que a idade.';
        _podeAposentar = false;
      });
      return false;
    }
    return true;
  }

  Future<void> _calcularAposentadoria() async {
    // Oculta o teclado antes de iniciar a requisição
    FocusScope.of(context).unfocus();

    if (!_validarCampos()) {
      return; // Interrompe se a validação falhar
    }

    final url = Uri.parse('$_backendUrl/APOS/calculoAposentadoria');

    setState(() {
      _isLoading = true; // Inicia o indicador de carregamento
      _resultadoMensagem = 'Calculando...'; // Mensagem de carregamento
      _podeAposentar = false; // Resetar para evitar resultado incorreto antes da resposta
    });

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'idade': int.tryParse(_idadeController.text) ?? 0,
          'contribuicao': int.tryParse(_contribuicaoController.text) ?? 0,
          'sexo': _sexoSelecionado, // envia o sexo para o backend
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _resultadoMensagem = data['mensagem'];
          _podeAposentar = data['podeAposentar'] ?? false;
        });
      } else {
        final data = jsonDecode(response.body);
        setState(() {
          _resultadoMensagem = data['mensagem'] ?? 'Erro na comunicação com o servidor: Status ${response.statusCode}.';
          _podeAposentar = false;
        });
      }
    } catch (e) {
      setState(() {
        _resultadoMensagem = 'Erro de rede: Verifique sua conexão ou se o servidor está rodando. Detalhes: $e';
        _podeAposentar = false;
      });
    } finally {
      setState(() {
        _isLoading = false; // Finaliza o indicador de carregamento
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Colors.teal.shade700; // Cor primária verde
    //final accentColor = Colors.teal.shade500; // Pode ser usado para detalhes, mas o primaryColor já atende

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora de Aposentadoria'), // Título da AppBar como na inspiração
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 4,
        automaticallyImplyLeading: false, // <--- AQUI: Remove a seta de voltar
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600), // Largura máxima maior
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch, // Estende os elementos
              children: [
                // Título e Ícone da tela
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.calculate, size: 48, color: primaryColor), // Ícone de calculadora
                    const SizedBox(width: 15),
                    Text(
                      'Calculadora de Aposentadoria', // Título como na inspiração
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                const SizedBox(height: 25), // Espaçamento maior
                const Text(
                  'Use essa ferramenta para verificar se você pode se aposentar com base na sua idade, anos de contribuição e sexo.', // Texto como na inspiração
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 17, color: Colors.black87),
                ),
                const SizedBox(height: 35), // Espaçamento maior

                // Campo para selecionar o sexo (Dropdown) - Primeiro campo
                _buildDropdownFormField<String>(
                  value: _sexoSelecionado,
                  onChanged: (value) {
                    setState(() {
                      _sexoSelecionado = value;
                    });
                  },
                  labelText: 'Sexo',
                  icon: Icons.person, // Ícone de pessoa
                  items: const [
                    DropdownMenuItem(value: 'F', child: Text('Feminino')),
                    DropdownMenuItem(value: 'M', child: Text('Masculino')),
                  ],
                  primaryColor: primaryColor,
                ),
                const SizedBox(height: 20), // Espaçamento entre campos

                // Campo de texto para Idade
                _buildTextField(
                  controller: _idadeController,
                  labelText: 'Idade atual',
                  icon: Icons.cake, // Ícone de bolo
                  keyboardType: TextInputType.number,
                  primaryColor: primaryColor,
                ),
                const SizedBox(height: 20), // Espaçamento entre campos

                // Campo de texto para Anos de contribuição
                _buildTextField(
                  controller: _contribuicaoController,
                  labelText: 'Anos de contribuição',
                  icon: Icons.access_time, // Ícone de relógio
                  keyboardType: TextInputType.number,
                  primaryColor: primaryColor,
                ),
                const SizedBox(height: 35), // Espaçamento maior antes do botão

                // Botão de Cálculo
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.calculate, size: 24), // Ícone de calculadora
                    label: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16), // Padding maior
                      child: Text(
                        _isLoading ? 'Calculando...' : 'Calcular',
                        style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold), // Fonte maior e negrito
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor, // Cor de fundo do botão
                      foregroundColor: Colors.white, // Cor do texto e ícone
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15), // Borda mais arredondada
                      ),
                      elevation: 5, // Sombra para o botão
                      minimumSize: const Size(double.infinity, 60), // Garante um tamanho mínimo
                    ),
                    onPressed: _isLoading ? null : _calcularAposentadoria,
                  ),
                ),
                const SizedBox(height: 40), // Espaçamento maior após o botão

                // Área de Resultado (inspirada no Card do CalculoScreen)
                if (_resultadoMensagem.isNotEmpty)
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: _podeAposentar ? Colors.green.shade400 : Colors.red.shade400,
                        width: 1.5,
                      ),
                    ),
                    elevation: 6,
                    color: _podeAposentar ? Colors.green.shade50 : Colors.red.shade50,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 24,
                        horizontal: 24,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _podeAposentar
                                ? Icons.check_circle_outline
                                : Icons.error_outline,
                            color: _podeAposentar ? Colors.green.shade700 : Colors.red.shade700,
                            size: 36,
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Text(
                              _resultadoMensagem,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: _podeAposentar ? Colors.green.shade900 : Colors.red.shade900,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Funções auxiliares para construção de widgets (para reutilização e organização) ---

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    required TextInputType keyboardType,
    required Color primaryColor,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor),
        ),
        enabledBorder: OutlineInputBorder( // Cor da borda quando não está focado
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor.withOpacity(0.5), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder( // Cor da borda quando focado
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        prefixIcon: Icon(icon, color: primaryColor),
        labelStyle: TextStyle(color: primaryColor),
        floatingLabelStyle: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
      ),
      cursorColor: primaryColor,
    );
  }

  Widget _buildDropdownFormField<T>({
    required T? value,
    required ValueChanged<T?> onChanged,
    required String labelText,
    required IconData icon,
    required List<DropdownMenuItem<T>> items,
    required Color primaryColor,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor),
        ),
        enabledBorder: OutlineInputBorder( // Cor da borda quando não está focado
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor.withOpacity(0.5), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder( // Cor da borda quando focado
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        prefixIcon: Icon(icon, color: primaryColor),
        labelStyle: TextStyle(color: primaryColor),
        floatingLabelStyle: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
      ),
      items: items,
      onChanged: onChanged,
      dropdownColor: Colors.white,
      iconEnabledColor: primaryColor,
      style: TextStyle(color: Colors.black87, fontSize: 16),
    );
  }
}