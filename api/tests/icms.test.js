const request = require('supertest');
const app = require('../app');

describe('Testa rota de cálculo de ICMS', () => {
  it('deve calcular corretamente o ICMS', async () => {
    const res = await request(app)
      .post('/api/icms')
      .send({ valorProduto: 200, aliquotaICMS: 18 });

    // Cálculo esperado: (200 * 18) / (100 + 18) = 3600/118 ≈ 30.50847
    expect(res.statusCode).toBe(200);
    expect(res.body.imposto).toBe("30.51"); // Arredondado para 2 casas decimais
  });

  it('deve retornar erro se faltar campos', async () => {
    const res = await request(app)
      .post('/api/icms')
      .send({});

    expect(res.statusCode).toBe(400);
    expect(res.body.erro).toBe('valorProduto e aliquotaICMS são obrigatórios');
  });
});