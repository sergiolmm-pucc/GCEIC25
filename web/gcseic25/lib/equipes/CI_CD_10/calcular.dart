import 'package:flutter/material.dart';

class CalcularPage extends StatefulWidget {
  const CalcularPage({super.key});

  @override
  State<CalcularPage> createState() => _CalcularPageState();
}

class _CalcularPageState extends State<CalcularPage> {
  final _formKey = GlobalKey<FormState>();
  final _salarioCtrl = TextEditingController();
  final _mesesCtrl = TextEditingController();
  DateTime? _dataAdmissao;
  String _tipoDesligamento = 'Não aplicável';

  // Resultados fictícios (simulados)
  double? salarioLiquido;
  double? inssEmpregado;
  double? inssEmpregador;
  double? fgtsMensal;
  double? fgtsRescisorio;
  double? decimoTerceiro;
  double? ferias;
  double? totalMensal;

  @override
  void dispose() {
    _salarioCtrl.dispose();
    _mesesCtrl.dispose();
    super.dispose();
  }

  Future<void> _selecionarData(BuildContext context) async {
    final data = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (data != null) {
      setState(() {
        _dataAdmissao = data;
      });
    }
  }

  void _calcular() {
    if (_formKey.currentState!.validate()) {
      final salario = double.tryParse(_salarioCtrl.text) ?? 0;
      final meses = int.tryParse(_mesesCtrl.text) ?? 0;

      // Simulação de resultados (valores fictícios)
      setState(() {
        inssEmpregado = salario * 0.08;
        inssEmpregador = salario * 0.08;
        fgtsMensal = salario * 0.08;
        fgtsRescisorio = salario * 0.032;
        decimoTerceiro = salario / 12 * meses;
        ferias = (salario / 12 * meses) + ((salario / 12 * meses) / 3);
        salarioLiquido = salario - inssEmpregado!;
        totalMensal = salario + inssEmpregador! + fgtsMensal! + fgtsRescisorio!;
      });
    }
  }

  Widget _resultado(String titulo, double? valor) {
    return ListTile(
      title: Text(titulo),
      trailing: Text(
        valor != null ? 'R\$ ${valor.toStringAsFixed(2)}' : '--',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cálculo de Encargos'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _salarioCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Salário bruto (R\$)',
                  border: OutlineInputBorder(),
                ),
                validator:
                    (v) =>
                        (v == null || v.isEmpty) ? 'Informe o salário' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _mesesCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Meses trabalhados',
                  border: OutlineInputBorder(),
                ),
                validator:
                    (v) =>
                        (v == null || int.tryParse(v) == null)
                            ? 'Informe um número válido'
                            : null,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _selecionarData(context),
                      child: Text(
                        _dataAdmissao == null
                            ? 'Selecionar data de admissão'
                            : 'Admissão: ${_dataAdmissao!.day}/${_dataAdmissao!.month}/${_dataAdmissao!.year}',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _tipoDesligamento,
                decoration: const InputDecoration(
                  labelText: 'Tipo de desligamento',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'Não aplicável',
                    child: Text('Não aplicável'),
                  ),
                  DropdownMenuItem(
                    value: 'Sem justa causa',
                    child: Text('Sem justa causa'),
                  ),
                  DropdownMenuItem(
                    value: 'Com justa causa',
                    child: Text('Com justa causa'),
                  ),
                  DropdownMenuItem(
                    value: 'Pedido de demissão',
                    child: Text('Pedido de demissão'),
                  ),
                ],
                onChanged: (value) {
                  setState(() => _tipoDesligamento = value!);
                },
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _calcular,
                  child: const Text('Calcular'),
                ),
              ),
              const Divider(height: 40, thickness: 1),
              const Text(
                'Resultados',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              _resultado('Salário líquido', salarioLiquido),
              _resultado('INSS (Empregado)', inssEmpregado),
              _resultado('INSS (Empregador)', inssEmpregador),
              _resultado('FGTS Mensal', fgtsMensal),
              _resultado('FGTS Rescisório', fgtsRescisorio),
              _resultado('13º salário (proporcional)', decimoTerceiro),
              _resultado('Férias + 1/3', ferias),
              _resultado('Custo mensal total (estimado)', totalMensal),
            ],
          ),
        ),
      ),
    );
  }
}
