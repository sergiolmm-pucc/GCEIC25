import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RecisaoScreen extends StatefulWidget {
  const RecisaoScreen({super.key});

  @override
  State<RecisaoScreen> createState() => _RecisaoScreenState();
}

class _RecisaoScreenState extends State<RecisaoScreen> with TickerProviderStateMixin {
  final _salarioController = TextEditingController();
  final _mesesTrabalhadosController = TextEditingController();
  final _saldoDiasController = TextEditingController();
  String _motivo = 'semJustaCausa';
  bool _feriasVencidas = false;
  double? _resultado;
  bool _loading = false;
  String? _error;

  late AnimationController _waveController;
  late AnimationController _fadeController;
  late Animation<double> _waveAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    _waveController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    );
    _waveAnimation = Tween<double>(begin: 0, end: 2 * math.pi)
        .animate(_waveController);
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(
          parent: _fadeController,
          curve: Curves.easeOutCubic,
        ));
    
    _waveController.repeat();
    _fadeController.forward();
  }

  @override
  void dispose() {
    _waveController.dispose();
    _fadeController.dispose();
    _salarioController.dispose();
    _mesesTrabalhadosController.dispose();
    _saldoDiasController.dispose();
    super.dispose();
  }

  Future<void> _calcularRescisao() async {
    final salario = double.tryParse(_salarioController.text.replaceAll(',', '.'));
    final mesesTrabalhados = int.tryParse(_mesesTrabalhadosController.text);
    final saldoDias = int.tryParse(_saldoDiasController.text);

    if (salario == null || salario <= 0 || mesesTrabalhados == null || saldoDias == null) {
      setState(() {
        _error = 'Preencha todos os campos corretamente.';
        _resultado = null;
      });
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
      _resultado = null;
    });

    try {
      final uri = Uri.parse('https://animated-occipital-buckthorn.glitch.me/ETEC/calcularRescisao');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'salarioBase': salario,
          'mesesTrabalhados': mesesTrabalhados,
          'diasTrabalhados': saldoDias,
          'motivo': _motivo,
          'feriasVencidas': _feriasVencidas,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 'success' && data['data'] != null) {
          setState(() {
            _resultado = (data['data']['recisao']['recisao'] as num).toDouble();
          });
        } else {
          setState(() {
            _error = 'Resposta inesperada da API.';
          });
        }
      } else {
        setState(() {
          _error = 'Erro ao calcular. Código: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Erro de conexão: $e';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: AnimatedBuilder(
        animation: Listenable.merge([_waveAnimation, _fadeAnimation]),
        builder: (context, child) {
          return Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.topCenter,
                radius: 2.0,
                colors: [
                  Color(0xFF1A1A1A),
                  Color(0xFF0F0F0F),
                  Color(0xFF000000),
                ],
              ),
            ),
            child: Stack(
              children: [
                // Background animated elements
                ...List.generate(4, (index) {
                  return Positioned(
                    top: 100 + (index * 200) + math.sin(_waveAnimation.value + index) * 40,
                    right: 30 + (index * 80) + math.cos(_waveAnimation.value + index) * 30,
                    child: Container(
                      width: 60 + (index * 15),
                      height: 60 + (index * 15),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            const Color(0xFFE97A12).withOpacity(0.04 + index * 0.01),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  );
                }),
                
                SafeArea(
                  child: Column(
                    children: [
                      // Custom App Bar
                      Transform.translate(
                        offset: Offset(0, (1 - _fadeAnimation.value) * -50),
                        child: Opacity(
                          opacity: _fadeAnimation.value,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () => Navigator.pop(context),
                                  child: Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.white.withOpacity(0.05),
                                      border: Border.all(
                                        color: const Color(0xFFE97A12).withOpacity(0.2),
                                        width: 1,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.arrow_back_ios_new,
                                      color: Color(0xFFE97A12),
                                      size: 20,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Rescisão',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'Calcule valores de rescisão',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.6),
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFFE97A12), Color(0xFFFF8C42)],
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.receipt_long_outlined,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      
                      // Content
                      Expanded(
                        child: Transform.translate(
                          offset: Offset(0, (1 - _fadeAnimation.value) * 30),
                          child: Opacity(
                            opacity: _fadeAnimation.value,
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                children: [
                                  const SizedBox(height: 40),
                                  
                                  // Salary Input Card
                                  _buildInputCard(
                                    controller: _salarioController,
                                    title: 'Salário Base',
                                    hint: 'Digite o salário base',
                                    icon: Icons.attach_money,
                                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                  ),
                                  
                                  const SizedBox(height: 20),
                                  
                                  // Months Input Card
                                  _buildInputCard(
                                    controller: _mesesTrabalhadosController,
                                    title: 'Meses Trabalhados',
                                    hint: 'Digite os meses trabalhados',
                                    icon: Icons.calendar_today,
                                    keyboardType: TextInputType.number,
                                  ),
                                  
                                  const SizedBox(height: 20),
                                  
                                  // Days Input Card
                                  _buildInputCard(
                                    controller: _saldoDiasController,
                                    title: 'Saldo de Dias',
                                    hint: 'Digite o saldo de dias',
                                    icon: Icons.av_timer,
                                    keyboardType: TextInputType.number,
                                  ),
                                  
                                  const SizedBox(height: 20),
                                  
                                  // Motivo Dropdown Card
                                  Transform.translate(
                                    offset: Offset(0, (1 - _fadeAnimation.value) * 20),
                                    child: Container(
                                      padding: const EdgeInsets.all(24),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.white.withOpacity(0.05),
                                        border: Border.all(
                                          color: const Color(0xFFE97A12).withOpacity(0.15),
                                          width: 1,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.2),
                                            blurRadius: 15,
                                            offset: const Offset(0, 5),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                width: 48,
                                                height: 48,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(14),
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      const Color(0xFFE97A12).withOpacity(0.2),
                                                      const Color(0xFFFF8C42).withOpacity(0.1),
                                                    ],
                                                  ),
                                                ),
                                                child: const Icon(
                                                  Icons.category_outlined,
                                                  color: Color(0xFFE97A12),
                                                  size: 24,
                                                ),
                                              ),
                                              const SizedBox(width: 16),
                                              const Expanded(
                                                child: Text(
                                                  'Motivo da Rescisão',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 20),
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(12),
                                              color: Colors.white.withOpacity(0.05),
                                              border: Border.all(
                                                color: const Color(0xFFE97A12).withOpacity(0.2),
                                                width: 1,
                                              ),
                                            ),
                                            child: DropdownButtonFormField<String>(
                                              value: _motivo,
                                              dropdownColor: const Color(0xFF1A1A1A),
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                              ),
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                contentPadding: const EdgeInsets.all(16),
                                                prefixIcon: Icon(
                                                  Icons.work_outline,
                                                  color: const Color(0xFFE97A12).withOpacity(0.7),
                                                ),
                                              ),
                                              items: const [
                                                DropdownMenuItem(
                                                  value: 'semJustaCausa',
                                                  child: Text('Sem Justa Causa'),
                                                ),
                                                DropdownMenuItem(
                                                  value: 'JustaCausa',
                                                  child: Text('Justa Causa'),
                                                ),
                                                DropdownMenuItem(
                                                  value: 'PedidoDemissao',
                                                  child: Text('Pedido de Demissão'),
                                                ),
                                              ],
                                              onChanged: (value) {
                                                if (value != null) {
                                                  setState(() {
                                                    _motivo = value;
                                                  });
                                                }
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  
                                  const SizedBox(height: 20),
                                  
                                  // Férias Vencidas Card
                                  Transform.translate(
                                    offset: Offset(0, (1 - _fadeAnimation.value) * 25),
                                    child: Container(
                                      padding: const EdgeInsets.all(24),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.white.withOpacity(0.05),
                                        border: Border.all(
                                          color: const Color(0xFFE97A12).withOpacity(0.15),
                                          width: 1,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.2),
                                            blurRadius: 15,
                                            offset: const Offset(0, 5),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 48,
                                            height: 48,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(14),
                                              gradient: LinearGradient(
                                                colors: [
                                                  const Color(0xFFE97A12).withOpacity(0.2),
                                                  const Color(0xFFFF8C42).withOpacity(0.1),
                                                ],
                                              ),
                                            ),
                                            child: const Icon(
                                              Icons.beach_access_outlined,
                                              color: Color(0xFFE97A12),
                                              size: 24,
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          const Expanded(
                                            child: Text(
                                              'Férias Vencidas',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          Transform.scale(
                                            scale: 1.2,
                                            child: Checkbox(
                                              value: _feriasVencidas,
                                              onChanged: (value) {
                                                setState(() {
                                                  _feriasVencidas = value ?? false;
                                                });
                                              },
                                              activeColor: const Color(0xFFE97A12),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  
                                  const SizedBox(height: 30),
                                  
                                  // Calculate Button
                                  Transform.translate(
                                    offset: Offset(0, (1 - _fadeAnimation.value) * 30),
                                    child: SizedBox(
                                      width: double.infinity,
                                      height: 56,
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: _loading ? null : _calcularRescisao,
                                          borderRadius: BorderRadius.circular(16),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(16),
                                              gradient: _loading 
                                                  ? LinearGradient(
                                                      colors: [
                                                        const Color(0xFFE97A12).withOpacity(0.5),
                                                        const Color(0xFFFF8C42).withOpacity(0.5),
                                                      ],
                                                    )
                                                  : const LinearGradient(
                                                      colors: [
                                                        Color(0xFFE97A12),
                                                        Color(0xFFFF8C42),
                                                      ],
                                                    ),
                                              boxShadow: !_loading ? [
                                                BoxShadow(
                                                  color: const Color(0xFFE97A12).withOpacity(0.3),
                                                  blurRadius: 15,
                                                  offset: const Offset(0, 8),
                                                ),
                                              ] : null,
                                            ),
                                            child: Center(
                                              child: _loading
                                                  ? const SizedBox(
                                                      width: 24,
                                                      height: 24,
                                                      child: CircularProgressIndicator(
                                                        color: Colors.white,
                                                        strokeWidth: 2,
                                                      ),
                                                    )
                                                  : const Text(
                                                      'Calcular Rescisão',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  
                                  const SizedBox(height: 40),
                                  
                                  // Error Message
                                  if (_error != null)
                                    Transform.translate(
                                      offset: Offset(0, (1 - _fadeAnimation.value) * 40),
                                      child: Container(
                                        padding: const EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(16),
                                          color: Colors.red.withOpacity(0.1),
                                          border: Border.all(
                                            color: Colors.red.withOpacity(0.3),
                                            width: 1,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.error_outline,
                                              color: Colors.red.shade300,
                                              size: 24,
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Text(
                                                _error!,
                                                style: TextStyle(
                                                  color: Colors.red.shade300,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  
                                  // Result Card
                                  if (_resultado != null)
                                    Transform.translate(
                                      offset: Offset(0, (1 - _fadeAnimation.value) * 50),
                                      child: Container(
                                        margin: const EdgeInsets.only(top: 20),
                                        padding: const EdgeInsets.all(28),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          gradient: LinearGradient(
                                            colors: [
                                              const Color(0xFFE97A12).withOpacity(0.15),
                                              const Color(0xFFFF8C42).withOpacity(0.1),
                                            ],
                                          ),
                                          border: Border.all(
                                            color: const Color(0xFFE97A12).withOpacity(0.3),
                                            width: 1,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color(0xFFE97A12).withOpacity(0.2),
                                              blurRadius: 20,
                                              offset: const Offset(0, 10),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          children: [
                                            Container(
                                              width: 64,
                                              height: 64,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(20),
                                                gradient: const LinearGradient(
                                                  colors: [
                                                    Color(0xFFE97A12),
                                                    Color(0xFFFF8C42),
                                                  ],
                                                ),
                                              ),
                                              child: const Icon(
                                                Icons.receipt_long,
                                                color: Colors.white,
                                                size: 32,
                                              ),
                                            ),
                                            const SizedBox(height: 20),
                                            const Text(
                                              'Total da Rescisão',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            Text(
                                              'R\$ ${_resultado!.toStringAsFixed(2)}',
                                              style: const TextStyle(
                                                fontSize: 32,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFFE97A12),
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              'Valor calculado com base nos dados informados',
                                              style: TextStyle(
                                                color: Colors.white.withOpacity(0.7),
                                                fontSize: 14,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  
                                  const SizedBox(height: 40),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInputCard({
    required TextEditingController controller,
    required String title,
    required String hint,
    required IconData icon,
    required TextInputType keyboardType,
  }) {
    return Transform.translate(
      offset: Offset(0, (1 - _fadeAnimation.value) * 20),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white.withOpacity(0.05),
          border: Border.all(
            color: const Color(0xFFE97A12).withOpacity(0.15),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFFE97A12).withOpacity(0.2),
                        const Color(0xFFFF8C42).withOpacity(0.1),
                      ],
                    ),
                  ),
                  child: Icon(
                    icon,
                    color: const Color(0xFFE97A12),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white.withOpacity(0.05),
                border: Border.all(
                  color: const Color(0xFFE97A12).withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: TextField(
                controller: controller,
                keyboardType: keyboardType,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(16),
                  prefixIcon: Icon(
                    icon,
                    color: const Color(0xFFE97A12).withOpacity(0.7),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}