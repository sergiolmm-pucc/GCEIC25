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
  String? _sexoSelecionado;

  String _resultadoMensagem = '';
  int? _anosFaltantes;
  bool _podeAposentarAgora = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _idadeController.dispose();
    _contribuicaoController.dispose();
    super.dispose();
  }

  bool _validarCampos() {
    final idade = int.tryParse(_idadeController.text);
    final contribuicao = int.tryParse(_contribuicaoController.text);

    if (idade == null || idade < 0 || idade > 120) {
      setState(() {
        _resultadoMensagem = 'Idade inválida. Digite um número entre 0 e 120.';
        _podeAposentarAgora = false;
        _anosFaltantes = null;
      });
      return false;
    }
    if (contribuicao == null || contribuicao < 0 || contribuicao > idade) {
      setState(() {
        _resultadoMensagem =
            'Anos de contribuição inválidos. Não pode ser negativo ou maior que a idade.';
        _podeAposentarAgora = false;
        _anosFaltantes = null;
      });
      return false;
    }
    if (_sexoSelecionado == null || _sexoSelecionado!.isEmpty) {
      setState(() {
        _resultadoMensagem = 'Por favor, selecione o sexo.';
        _podeAposentarAgora = false;
        _anosFaltantes = null;
      });
      return false;
    }
    return true;
  }

  Future<void> _simularAposentadoria() async {
    FocusScope.of(context).unfocus();

    if (!_validarCampos()) {
      return;
    }

    final url = Uri.parse('https://animated-occipital-buckthorn.glitch.me/APOS/calculoPontuacao');

    setState(() {
      _isLoading = true;
      _resultadoMensagem = 'Simulando sua projeção de aposentadoria...';
      _podeAposentarAgora = false;
      _anosFaltantes = null;
    });

    final int? idade = int.tryParse(_idadeController.text);
    final int? contribuicao = int.tryParse(_contribuicaoController.text);
    final String? sexo = _sexoSelecionado;

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'idade': idade,
          'contribuicao': contribuicao,
          'sexo': sexo,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _podeAposentarAgora = (data['anosRestantes'] ?? 0) == 0;
          _anosFaltantes = data['anosRestantes'];
          _resultadoMensagem = data['mensagem'] ?? 'Erro ao obter mensagem.';

          if (data['erro'] == true) {
            _resultadoMensagem =
                data['mensagem'] ?? 'Ocorreu um erro no servidor.';
            _podeAposentarAgora = false;
            _anosFaltantes = null;
          }
        });
      } else if (response.statusCode == 400) {
        final data = json.decode(response.body);
        setState(() {
          _podeAposentarAgora = false;
          _anosFaltantes = null;
          _resultadoMensagem =
              data['mensagem'] ?? 'Erro de validação no servidor.';
        });
      } else {
        setState(() {
          _podeAposentarAgora = false;
          _anosFaltantes = null;
          _resultadoMensagem =
              'Erro ao conectar ao servidor: Status ${response.statusCode}. Tente novamente.';
        });
      }
    } catch (e) {
      setState(() {
        _podeAposentarAgora = false;
        _anosFaltantes = null;
        _resultadoMensagem =
            'Erro de rede: Verifique sua conexão ou se o servidor está rodando. Detalhes: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Colors.teal.shade700;
    final MaterialColor baseTealColor = Colors.teal;

    return Scaffold(
      appBar: AppBar(title: const Text('')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.timeline, size: 48, color: primaryColor),
                    const SizedBox(width: 15),
                    Flexible(
                      child: Text(
                        'Simular Aposentadoria',
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                const Text(
                  'Insira seus dados para simular em quantos anos você poderá se aposentar, baseando-se nas regras de pontuação.',
                  // Texto explicativo
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 17, color: Colors.black87),
                ),
                const SizedBox(height: 35),

                _buildTextField(
                  controller: _idadeController,
                  labelText: 'Sua Idade Atual',
                  icon: Icons.person,
                  keyboardType: TextInputType.number,
                  primaryColor: primaryColor,
                ),

                const SizedBox(height: 20),

                _buildTextField(
                  controller: _contribuicaoController,
                  labelText: 'Anos de Contribuição Atuais',
                  icon: Icons.work,
                  keyboardType: TextInputType.number,
                  primaryColor: primaryColor,
                ),

                const SizedBox(height: 20),

                _buildDropdownFormField<String>(
                  value: _sexoSelecionado,
                  onChanged: (value) {
                    setState(() {
                      _sexoSelecionado = value;
                    });
                  },
                  labelText: 'Sexo',
                  icon: Icons.wc,
                  items: const [
                    DropdownMenuItem(value: 'M', child: Text('Masculino')),
                    DropdownMenuItem(value: 'F', child: Text('Feminino')),
                  ],
                  primaryColor: primaryColor,
                ),

                const SizedBox(height: 35),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon:
                        _isLoading
                            ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                            : const Icon(Icons.flash_on, size: 28),
                    label: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      child: Text(
                        _isLoading ? 'Calculando...' : 'Simular Projeção',
                        // Texto mais claro
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                      minimumSize: const Size(double.infinity, 60),
                    ),
                    onPressed:
                        _isLoading
                            ? null
                            : _simularAposentadoria, // CHAMA A FUNÇÃO CORRETA
                  ),
                ),

                const SizedBox(height: 40),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color:
                        _resultadoMensagem.isEmpty
                            ? Colors.grey[200]
                            : (_podeAposentarAgora
                                ? Colors.green[100]
                                : baseTealColor[100]), // Usar baseTealColor
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color:
                          _resultadoMensagem.isEmpty
                              ? Colors.grey.shade400
                              : (_podeAposentarAgora
                                  ? Colors.green.shade600
                                  : (_anosFaltantes != null &&
                                          _anosFaltantes! > 0
                                      ? baseTealColor
                                          .shade400 // Usar baseTealColor.shade400
                                      : Colors.red.shade400)),
                      // Vermelho para erro/validação
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    // Usar Column para exibir múltiplas linhas de texto
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        _resultadoMensagem.isEmpty
                            ? 'Aguardando simulação...'
                            : _resultadoMensagem,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color:
                              _resultadoMensagem.isEmpty
                                  ? Colors.grey[600]
                                  : (_podeAposentarAgora
                                      ? Colors.green[800]
                                      : (_anosFaltantes != null &&
                                              _anosFaltantes! > 0
                                          ? baseTealColor
                                              .shade800 // Usar baseTealColor.shade800
                                          : Colors
                                              .red[800])), // Vermelho para erro/validação
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (_anosFaltantes != null &&
                          _anosFaltantes! > 0 &&
                          !_podeAposentarAgora) // Exibe os anos faltantes
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Text(
                            'Você precisará de mais $_anosFaltantes ano(s) de contribuição.',
                            style: TextStyle(
                              fontSize: 16,
                              color: baseTealColor.shade600,
                              // Usar baseTealColor.shade600
                              fontStyle: FontStyle.italic,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      if (_podeAposentarAgora &&
                          _anosFaltantes != null &&
                          _anosFaltantes == 0) // Mensagem de parabéns
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Text(
                            'Parabéns! Você já atende aos critérios de aposentadoria.',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.green.shade800,
                              fontStyle: FontStyle.italic,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

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
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: primaryColor.withOpacity(0.5),
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        prefixIcon: Icon(icon, color: primaryColor),
        labelStyle: TextStyle(color: primaryColor),
        floatingLabelStyle: TextStyle(
          color: primaryColor,
          fontWeight: FontWeight.bold,
        ),
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
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: primaryColor.withOpacity(0.5),
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        prefixIcon: Icon(icon, color: primaryColor),
        labelStyle: TextStyle(color: primaryColor),
        floatingLabelStyle: TextStyle(
          color: primaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      items: items,
      onChanged: onChanged,
      dropdownColor: Colors.white,
      iconEnabledColor: primaryColor,
      style: TextStyle(color: Colors.black87, fontSize: 16),
    );
  }
}
