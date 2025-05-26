const request = require('supertest');
const app = require('../app');

describe('Testa rota de cálculo de ISS', () => {
  it('deve calcular corretamente o ISS', async () => {
    const res = await request(app)
      .post('/api/iss')
      .send({ valorServico: 500, aliquotaISS: 5 });

    // Cálculo esperado: 500 * 5 / 100 = 25
    expect(res.statusCode).toBe(200);
    expect(res.body.imposto).toBe("25.00"); // Arredondado para 2 casas decimais
  });

  it('deve retornar erro se faltar campos', async () => {
    const res = await request(app)
      .post('/api/iss')
      .send({});

    expect(res.statusCode).toBe(400);
    expect(res.body.erro).toBe('valorServico e aliquotaISS são obrigatórios');
  });

  it('deve retornar erro se os valores não forem numéricos', async () => {
    const res = await request(app)
      .post('/api/iss')
      .send({ valorServico: "abc", aliquotaISS: "xyz" });

    expect(res.statusCode).toBe(400);
    expect(res.body.erro).toBe('Os valores devem ser números válidos');
  });
});
