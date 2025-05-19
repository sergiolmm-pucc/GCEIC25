const request = require('supertest');
const app = require('./server'); // importa o app configurado

describe('Testa rota de cálculo de IPI', () => {
  it('deve calcular corretamente o IPI', async () => {
    const res = await request(app)
      .post('/impostos/ipi')  // <-- corrigido aqui
      .send({ valorProduto: 100, aliquotaIPI: 10 });

    expect(res.statusCode).toBe(200);
    expect(res.body.imposto).toBe("10.00");
  });

  it('deve retornar erro se faltar campos', async () => {
    const res = await request(app)
      .post('/impostos/ipi')  // <-- corrigido aqui
      .send({ valorProduto: 100 });

    expect(res.statusCode).toBe(400);
    expect(res.body.erro).toBe('Informe valorProduto e aliquotaIPI');
  });
});
