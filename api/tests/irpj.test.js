const request = require('supertest');
const app = require('../server'); // importa o app configurado

describe('Testa rota de cálculo de IRPJ', () => {
  it('deve calcular corretamente o IRPJ no regime de Lucro Real (abaixo do limite)', async () => {
    const res = await request(app)
      .post('/impostos/irpj')
      .send({ lucroTributavel: 50000, isLucroReal: true });

    expect(res.statusCode).toBe(200);
    expect(res.body.imposto).toBe("7500.00"); // 15% de 50.000
    expect(res.body.aliquotaIRPJ).toBe("15.00");
    expect(res.body.regime).toBe('Lucro Real');
  });

  it('deve calcular corretamente o IRPJ no regime de Lucro Real (acima do limite)', async () => {
    const res = await request(app)
      .post('/impostos/irpj')
      .send({ lucroTributavel: 80000, isLucroReal: true });

    expect(res.statusCode).toBe(200);
    // Cálculo esperado: (60.000 * 15%) + (20.000 * 10%) = 9.000 + 2.000 = 11.000
    expect(res.body.imposto).toBe("11000.00");
    expect(Number(res.body.aliquotaIRPJ)).toBeCloseTo(13.75); // (11.000 / 80.000) * 100
    expect(res.body.regime).toBe('Lucro Real');
  });

  it('deve calcular corretamente o IRPJ no regime de Lucro Presumido', async () => {
    const res = await request(app)
      .post('/impostos/irpj')
      .send({ lucroTributavel: 50000, isLucroReal: false });

    expect(res.statusCode).toBe(200);
    expect(res.body.imposto).toBe("7500.00"); // 15% de 50.000
    expect(res.body.aliquotaIRPJ).toBe("15.00");
    expect(res.body.regime).toBe('Lucro Presumido');
  });

  it('deve retornar erro se faltar campo obrigatório', async () => {
    const res = await request(app)
      .post('/impostos/irpj')
      .send({ isLucroReal: true });

    expect(res.statusCode).toBe(400);
    expect(res.body.erro).toBe('lucroTributavel é obrigatório');
  });

  it('deve retornar erro se valor não for numérico', async () => {
    const res = await request(app)
      .post('/impostos/irpj')
      .send({ lucroTributavel: 'abc', isLucroReal: true });

    expect(res.statusCode).toBe(400);
    expect(res.body.erro).toBe('O valor deve ser um número válido');
  });
});