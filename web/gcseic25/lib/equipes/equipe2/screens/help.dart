import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 90, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 76,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(text: 'Como\npodemos '),
                    TextSpan(
                      text: 'ajudar?',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              const Text(
                'Bem-vindo ao assistente de cálculo SplashMath!\n\n'
                'Nosso sistema foi desenvolvido para estimar com praticidade todos os custos envolvidos na construção e manutenção da sua piscina.\n\n'
                'Você pode utilizar os módulos disponíveis para realizar os seguintes cálculos:\n'
                '- Volume da piscina\n'
                '- Materiais elétricos e hidráulicos\n'
                '- Gasto com água para enchimento\n'
                '- Custo mensal de manutenção\n'
                '- Custos iniciais com mobilização (MOB)\n\n'
                'Preencha cada módulo de forma individual com os dados solicitados. Após clicar em CALCULAR em cada um deles, o valor será enviado para a tela inicial, onde o custo total será somado automaticamente.\n\n'
                'Abaixo, explicamos como preencher cada módulo corretamente e apresentamos uma imagem de exemplo para facilitar o entendimento visual.',
                style: TextStyle(fontSize: 16, height: 1.6),
              ),
              const SizedBox(height: 40),

              // Volume
              const HelpCard(
                title: 'Cálculo do volume da piscina',
                description: '''
Selecione o formato da piscina: Retangular, Circular, Oval ou Irregular.

- Para cada formato, preencha os campos exigidos: comprimento, largura e profundidade (em metros).
- O cálculo é feito com base nas fórmulas geométricas correspondentes ao tipo selecionado.
- No caso de piscinas irregulares, o sistema utiliza uma aproximação do volume médio com base nas medidas informadas.
- Após preencher todos os campos obrigatórios, clique em CALCULAR para obter o volume em metros cúbicos (m³).
''',
              ),
              Row(
                children: [
                  Flexible(
                    child: imageBlock('assets/equipe2/volume1.png'),
                  ),
                  const SizedBox(width: 16),
                  Flexible(
                    child: imageBlock('assets/equipe2/volume2.png'),
                  ),
                ],
              ),
              const Divider(
                color: Color(0xFF347CA5),
                thickness: 1.2,
                height: 40,
              ),

              // Elétrica
              const HelpCard(
                title: 'Cálculo do custo de material elétrico',
                description: '''
Informe a quantidade e o preço unitário (em R\$) de cada item utilizado na instalação elétrica da piscina:

- Luminária subaquática
- Cabo elétrico (metros + valor por metro)
- Quadro de comando
- Disjuntor
- Programador

Após preencher os campos obrigatórios, clique em CALCULAR. O sistema somará os custos totais de cada item e exibirá o valor final da parte elétrica.
''',
              ),
              imageBlock('assets/equipe2/page_material_eletrico.png'),
              const Divider(color: Color(0xFF347CA5), thickness: 1.2, height: 40),

              // Hidráulica
              const HelpCard(
                title: 'Cálculo do custo da parte hidráulica',
                description: '''
Preencha os campos com os componentes e dados da instalação hidráulica:

- Bomba e Filtro: informe o valor de cada equipamento.
- Tubulações (m): total de metros de tubulação.
- Tipo da tubulação.
- Preço por metro.
- Conexões: valor total estimado das conexões.

Clique em CALCULAR para obter o custo total estimado da parte hidráulica.
''',
              ),
              imageBlock('assets/equipe2/page_hidraulica.png'),
              const Divider(color: Color(0xFF347CA5), thickness: 1.2, height: 40),

              // Água
              const HelpCard(
                title: 'Cálculo do custo da água',
                description: '''
Informe o volume de água necessário para encher a piscina (em m³) e a tarifa por metro cúbico (R\$ por m³).

- A tarifa varia conforme a região (média entre R\$ 5,00 e R\$ 10,00).
- O sistema multiplica o volume pela tarifa e exibe o custo total da água utilizada.
''',
              ),
              imageBlock('assets/equipe2/page_agua.png'),
              const Divider(color: Color(0xFF347CA5), thickness: 1.2, height: 40),

              // Manutenção
              const HelpCard(
                title: 'Cálculo de manutenção da piscina',
                description: '''
Preencha os campos com os seguintes dados mensais:

- Volume da piscina
- Energia da bomba (em kWh)
- Produtos químicos (tipo e valor)
- Mão de obra (valor mensal ou estimado)

Clique em CALCULAR para obter o custo médio mensal de manutenção da piscina.
''',
              ),
              imageBlock('assets/equipe2/page_manutencao.png'),
              const Divider(color: Color(0xFF347CA5), thickness: 1.2, height: 40),

              // MOB
              const HelpCard(
                title: 'Cálculo do MOB (Mobilização)',
                description: '''
Informe os valores dos itens relacionados à mobilização da obra:

- Transporte de materiais
- Instalação de canteiros
- Mão de obra
- Equipamentos

Após preencher os campos, clique em CALCULAR para visualizar o custo total da mobilização inicial do projeto.
''',
              ),
              imageBlock('assets/equipe2/page_mob.png'),
              const Divider(color: Color(0xFF347CA5), thickness: 1.2, height: 40),
              const HelpCard(
              title: 'Tela final: cálculo total da obra',
              description: '''
Após preencher todos os módulos e clicar em CALCULAR em cada um deles, os valores individuais são automaticamente enviados para a tela inicial.

Nela, você poderá visualizar:
- O custo individual de cada componente (volume, elétrica, hidráulica, etc.);
- O total somado de todos os módulos preenchidos;
- Uma visualização clara e centralizada dos dados.

Essa tela permite revisar o orçamento total da obra antes de iniciar qualquer execução.
              ''',
              ),
              imageBlock('assets/equipe2/page_gasto_total.png'),
              const Divider(color: Color(0xFF347CA5), thickness: 1.2, height: 40),

              const HelpCard(
                title: 'Dúvidas comuns',
                description: '''
- Os campos devem ser preenchidos apenas com números.
- O botão "Calcular" só é habilitado após todos os campos obrigatórios estarem preenchidos.
- Os resultados são exibidos em reais (R\$), com base na estimativa informada.
''',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget imageBlock(String path) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Color(0xFF347CA5), width: 1.5),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            path,
            height: 280,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

class HelpCard extends StatelessWidget {
  final String title;
  final String description;

  const HelpCard({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Color(0xFF347CA5), width: 1.5),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: const TextStyle(
                fontSize: 16,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
