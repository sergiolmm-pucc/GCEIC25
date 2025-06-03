const etecService = require("../services/etecService");

describe("Testes para o cálculo do ETEC", () => {
  test("Calcular o custo mensal da empregada", () => {
    const dados = {
      salario: 1518,
    };

    const resultado = etecService.calcularCustoMensal(dados);

    expect(resultado).toBe(1935.45);
  });

  test("Calcular férias mensal", () => {
    const dados = {
      salario: 1518,
    };

    const resultado = etecService.calcularFerias(dados);

    expect(resultado).toBe(202.4);
  });

  test("Calcular décimo terceiro proporcional", () => {
    const dados = {
      salario: 1518,
      mesesTrabalhados: 10,
    };

    const resultado = etecService.calcularDecimoTerceiro(dados);

    expect(resultado).toEqual({
      bruto: 1265,
      inss: 94.88,
      liquido: 1170.13,
    });
  });

  test("Calcular do eSocial", () => {
    const dados = {
      salario: 1200,
      dependentes: 2,
    };

    const resultado = etecService.calcularESocial(dados);

    expect(resultado).toBe(205.92);
  });

  test("Calcular valor de rescisão", () => {
    const dados = {
      salarioBase: 2000,
      mesesTrabalhados: 13,
      diasTrabalhados: 18,
      motivo: "semJustaCausa",
      feriasVencidas: true,
    };

    const resultado = etecService.calcularRecisao(dados);
    expect(resultado).toStrictEqual({
      recisao: 9167.56,
      avisoPrevio: 2000,
      saldoSalario: 1200,
      ferias: 2888.89,
      decimoTerceiro: 166.67,
      fgts: 2080,
      multaFgts: 832,
    });
  });
});
