const piscinaService = require('../services/piscina3Service');

describe('Teste de cálculo de piscina', () => {
  test('Calcula corretamente os valores', () => {
    const dados = {
      largura: 4,
      comprimento: 5,
      profundidade: 1.5,
      precoAgua: 4,
      custoEletrico: 1500,
      custoHidraulico: 1000,
      custoManutencaoMensal: 200
    };

    const resultado = piscinaService.calcularTodosCustos(dados);

    expect(resultado.volume).toBe('30.00 m³');
    expect(resultado.custoAgua).toBe('120.00');
    expect(resultado.custoConstrucao).toBe('2620.00');
    expect(resultado.manutencaoMensal).toBe('200.00');
  });
});
