const etecService = require('../services/etecService');

describe('Testes para o cálculo do ETEC', () => {
  test('Calcular o custo mensal da empregada', () => {
    const dados = {
        salario: 1518
    };

    const resultado = etecService.calcularCustoMensal(dados);

    expect(resultado).toBe(1935.45);
  });
});