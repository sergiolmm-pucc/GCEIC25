const request = require('supertest');
const app = require('../server'); 

describe('Testa rota de cálculo de IPI', () => {

  it('deve calcular corretamente o IPI com valorProduto e aliquotaIPI', async () => {
    const res = await request(app)
      .post('/impostos/ipi')
      .send({ valorProduto: 100, aliquotaIPI: 10 });

    expect(res.statusCode).toBe(200);
    expect(res.body.imposto).toBe("10.00");
  });

  it('deve calcular corretamente o IPI incluindo frete e despesas acessórias', async () => {
    const res = await request(app)
      .post('/impostos/ipi')
      .send({
        valorProduto: 100,
        aliquotaIPI: 10,
        frete: 50,
        despesasAcessorias: 50
      });

    // Base de cálculo: 100 + 50 + 50 = 200
    // IPI: 200 * 10% = 20
    expect(res.statusCode).toBe(200);
    expect(res.body.baseCalculo).toBe("200.00");
    expect(res.body.imposto).toBe("20.00");
  });

  it('deve retornar erro se faltar campos obrigatórios', async () => {
    const res = await request(app)
      .post('/impostos/ipi')
      .send({ valorProduto: 100 }); // faltando aliquotaIPI

    expect(res.statusCode).toBe(400);
    expect(res.body.erro).toBe('valorProduto e aliquotaIPI são obrigatórios');
  });
});
